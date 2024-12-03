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

    fileprivate(set) var isFetchingData = false
    fileprivate(set) var error: Error?

    // MARK: - Methods

    @MainActor
    func fetchData(context: ModelContext, refreshing: Bool = false) async {
        isFetchingData = true

        let endpoint = AlgoliaEndpoint.latestStories()

        do {
            let searchResult: StoriesSearchResultDTO = try await AlgoliaService.shared.fetchData(from: endpoint)

            if refreshing {
                try context.delete(model: Story.self)
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

class MockedStoryFeedViewModel: StoryFeedViewModel {

    var fileName: String

    init(fileName: String = "mocked_stories.json") {
        self.fileName = fileName
        super.init()
    }

    @MainActor
    override func fetchData(context: ModelContext, refreshing: Bool = false) async {
        isFetchingData = true

        do {
            let searchResult: StoriesSearchResultDTO = try parseJSON(from: fileName)
            searchResult.stories.forEach { dto in
                context.insertIfNotExisting(Story(from: dto))
            }
        } catch {
            self.error = error
        }

        isFetchingData = false
    }

}
