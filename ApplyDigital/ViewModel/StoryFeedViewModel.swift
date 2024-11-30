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

    func fetchData() async {
        isFetchingData = true
        let endpoint = AlgoliaEndpoint.latestStories()

        do {
            let searchResult: StoriesSearchResult = try await AlgoliaService.fetchData(from: endpoint)
            data = searchResult.stories
        } catch {
            self.error = error
        }

        isFetchingData = false
    }

}
