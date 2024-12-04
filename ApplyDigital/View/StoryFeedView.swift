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

    @Query(filter: #Predicate { element in !element.isDeleted },
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
                    NavigationLink(destination: destinationView(for: story)) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(story.title ?? "<untitled>")
                                .font(.headline)
                            Text(subHeadline(for: story))
                                .font(.subheadline)
                        }
                    }
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
                        VStack(spacing: 16) {
                            Text("No stories yet")
                                .backgroundStyle(Color.red)
                            Button("Try to fetch") {
                                Task {
                                    await viewModel.fetchData(context: modelContext, refreshing: true)
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                    }
                }
            }
            .refreshable {
                await viewModel.fetchData(context: modelContext, refreshing: true)
            }
        }
        .alert("Failed to fetch data", isPresented: showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Try again later.")
        }
        .task {
            await viewModel.fetchData(context: modelContext, refreshing: true)
        }
    }

    // MARK: - Helper methods

    private func subHeadline(for story: Story) -> String {
        let author = story.author ?? "<no author>"

        guard let date = story.createdAt else {
            return author
        }

        return author + " - \(timeText(for: date))"
    }

    private func timeText(for date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        formatter.dateTimeStyle = .named

        return formatter.localizedString(for: date, relativeTo: Date.now)
    }

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

    private func destinationView(for story: Story) -> some View {
        guard let url = story.url, let validURL = URL(string: url) else {
            return AnyView(
                Text("Could not load the story because the URL is invalid")
                    .padding()
            )
        }

        return AnyView(WebView(url: validURL))
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
        .environment(MockedStoryFeedViewModel() as StoryFeedViewModel)
}

#Preview("Empty") {
    StoryFeedView()
        .modelContainer(previewContainer)
        .environment(MockedStoryFeedViewModel(fileName: "mocked_empty_stories.json") as StoryFeedViewModel)
}

#Preview("Error") {
    StoryFeedView()
        .modelContainer(previewContainer)
        .environment(MockedStoryFeedViewModel(fileName: "invalid file name") as StoryFeedViewModel)
}
