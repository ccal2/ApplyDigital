//
//  StoryFeedView.swift
//  ApplyDigital
//
//  Created by Carolina Lopes on 28/11/24.
//

import SwiftData
import SwiftUI

struct StoryFeedView: View {

    // MARK: - Properties

    @Query(filter: Story.Predicates.notDeleted,
           sort: \Story.createdAt,
           order: .reverse)
    var stories: [Story]

    @Environment(\.modelContext) var modelContext
    @Environment(StoryFeedViewModel.self) var viewModel

    private var showErrorAlert: Binding<Bool> {
        Binding(
            get: { viewModel.error != nil },
            set: { if !$0 { viewModel.clearError() } }
        )
    }

    // MARK: - Views

    var body: some View {
        NavigationStack {
            List {
                ForEach(stories) { story in
                    StoryCellView(story: story)
                }
                .onDelete(perform: deleteStories)
            }
            .overlay {
                if stories.isEmpty {
                    if viewModel.isFetchingData {
                        VStack {
                            ProgressView()
                            Text("Fetching stories…")
                        }
                    } else {
                        noStoriesView
                    }
                }
            }
            .refreshable {
                await viewModel.fetchStories(with: modelContext)
            }
        }
        .alert("Failed to fetch data", isPresented: showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Try again later.")
        }
        .task {
            await viewModel.fetchStories(with: modelContext)
        }
    }

    var noStoriesView: some View {
        VStack(spacing: 16) {
            Text("No stories yet")
                .backgroundStyle(Color.red)
            Button("Try to fetch") {
                Task {
                    await viewModel.fetchStories(with: modelContext)
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    // MARK: - Helper methods

    private func alertErrorMessage(for error: Error?) -> String {
        guard let error else {
            return ""
        }

        return "Error: \"\(error.localizedDescription)\".\n"
    }

    private func deleteStories(_ indexSet: IndexSet) {
        for index in indexSet {
            stories[index].delete()
            try? modelContext.save()
        }
    }

}

// MARK: - Previews

@MainActor
let previewContainer: ModelContainer = {
    do {
        return try ModelContainer(for: Story.self,
                                  configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    } catch {
        fatalError("Failed to create container.")
    }
}()

#Preview("Valid data") {
    StoryFeedView()
        .modelContainer(previewContainer)
        .environment(StoryFeedViewModel(dataService: StoryDataServiceStub()))
}

#Preview("Empty") {
    StoryFeedView()
        .modelContainer(previewContainer)
        .environment(StoryFeedViewModel(dataService: StoryDataServiceStub(
            fileName: FileNameConstants.StoriesSearchResult.empty
        )))
}

#Preview("Error") {
    StoryFeedView()
        .modelContainer(previewContainer)
        .environment(StoryFeedViewModel(dataService: StoryDataServiceStub(fileName: FileNameConstants.invalidName)))
}
