//
//  StoryFeedViewModel.swift
//  ApplyDigital
//
//  Created by Carolina Lopes on 29/11/24.
//

import SwiftData
import SwiftUI

@MainActor
@Observable
class StoryFeedViewModel {

    // MARK: - Properties

    private(set) var isFetchingData = false
    private(set) var error: Error?

    private let dataService: StoryDataService

    // MARK: - Methods

    init(dataService: StoryDataService = AlgoliaService.shared) {
        self.dataService = dataService
    }

    @MainActor
    func fetchStories(with context: ModelContext, refreshing: Bool = true) async {
        isFetchingData = true

        let endpoint = AlgoliaEndpoint.latestStories()

        do {
            let searchResult: StoriesSearchResultDTO = try await dataService.fetchData(from: endpoint)

            if refreshing {
                try context.delete(model: Story.self, where: Story.Predicates.notDeleted)
                try context.save()
            }

            searchResult.stories.forEach { dto in
                context.insertIfNotExisting(Story(from: dto))
            }
        } catch {
            self.error = error
        }

        isFetchingData = false
    }

    func clearError() {
        error = nil
    }

}
