//
//  StoryFeedView.swift
//  ApplyDigital
//
//  Created by Carolina Lopes on 28/11/24.
//

import SwiftUI

struct StoryFeedView: View {

    // MARK: - Properties

    @Environment(StoryFeedViewModel.self) var viewModel

    // MARK: - Views

    var body: some View {
        Group {
            List {
                ForEach(viewModel.data) { story in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(story.title ?? "<untitled>")
                            .font(.headline)
                        Text(subHeadline(for: story))
                            .font(.subheadline)
                    }

                }
            }
            .overlay {
                if viewModel.data.isEmpty {
                    if viewModel.isFetchingData {
                        VStack {
                            ProgressView()
                            Text("Fetching stories…")
                        }
                    } else {
                        if let error = viewModel.error {
                            VStack(spacing: 16) {
                                VStack(alignment: .leading) {
                                    Text("Failed to fetch data.")
                                        .font(.callout)
                                    Text("Error: \"\(error.localizedDescription)\"")
                                        .font(.footnote)
                                }
                                Button("Try again") {
                                    Task {
                                        await viewModel.fetchData(refreshing: true)
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            .padding()
                        } else {
                            Text("No stories yet")
                                .backgroundStyle(Color.red)
                        }
                    }
                }
            }
            .refreshable {
                // TODO: See if I should use Task here
                await viewModel.fetchData(refreshing: true)
            }
        }
        .task {
            await viewModel.fetchData()
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

}

// MARK: - Preview

#Preview {
    StoryFeedView()
        .environment(StoryFeedViewModel())
}
