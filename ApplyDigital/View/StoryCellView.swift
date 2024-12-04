//
//  StoryCellView.swift
//  ApplyDigital
//
//  Created by Carolina Lopes on 04/12/24.
//

import SwiftUI

struct StoryCellView: View {

    // MARK: - Properties

    let story: Story

    var subHeadline: String {
        let author = story.author ?? "<no author>"

        guard let date = story.createdAt else {
            return author
        }

        return author + " - \(timeText(for: date))"
    }

    // MARK: - Views

    var body: some View {
        NavigationLink(destination: destinationView) {
            VStack(alignment: .leading, spacing: 10) {
                Text(story.title ?? "<untitled>")
                    .font(.headline)
                Text(subHeadline)
                    .font(.subheadline)
            }
        }
    }

    var destinationView: some View {
        guard let url = story.url, let validURL = URL(string: url) else {
            return AnyView(
                Text("Could not load the story because the URL is invalid")
                    .padding()
            )
        }

        return AnyView(WebView(url: validURL))
    }

    // MARK: - Helper methods

    private func timeText(for date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        formatter.dateTimeStyle = .named

        return formatter.localizedString(for: date, relativeTo: Date.now)
    }

}
