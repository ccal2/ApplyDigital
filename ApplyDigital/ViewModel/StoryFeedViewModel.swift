//
//  StoryFeedViewModel.swift
//  ApplyDigital
//
//  Created by Carolina Lopes on 29/11/24.
//

import SwiftUI

@MainActor
@Observable
class StoryFeedViewModel {

    // MARK: - Properties

    private(set) var isFetchingData = false

    fileprivate(set) var data: [Story] = []
    fileprivate(set) var error: Error?

    // MARK: - Methods

    func fetchData(refreshing: Bool = false) async {
        isFetchingData = true

        if refreshing {
            error = nil
        }

        let endpoint = AlgoliaEndpoint.latestStories()

        do {
            let searchResult: StoriesSearchResult = try await AlgoliaService.fetchData(from: endpoint)
            if refreshing {
                data = searchResult.stories
            } else {
                data.append(contentsOf: searchResult.stories)
            }

            error = nil
        } catch {
            self.error = error

            if refreshing {
                data = []
            }
        }

        isFetchingData = false
    }

}