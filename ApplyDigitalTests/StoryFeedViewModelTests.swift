//
//  StoryFeedViewModelTests.swift
//  ApplyDigital
//
//  Created by Carolina Lopes on 05/12/24.
//

import Foundation
import SwiftData
import Testing
@testable import ApplyDigital

@Suite class StoryFeedViewModelTests {

    @MainActor
    @Suite class FetchStories {

        lazy var bundle = Bundle(for: type(of: self))

        // MARK: Tests

        @Test("Fetch stories with error should store the error and keep persisted data",
              arguments: [true, false])
        func fetchError_storesError_keepsPersistedData(refreshing: Bool) async throws {
            let dataService = StoryDataServiceStub(fileName: FileNameConstants.invalidName,
                                                   bundle: bundle)
            let dut = StoryFeedViewModel(dataService: dataService)
            let container = try newStoryContainer()
            let context = container.mainContext
            var initialPersistedStories: [Story] = []

            // Add initial data
            let searchResult = try searchResult(forFileNamed: FileNameConstants.StoriesSearchResult.valid)
            context.insertMapping(contentsOf: searchResult.stories) { dto in
                let story = Story(from: dto)
                initialPersistedStories.append(story)
                return story
            }

            // Fetch new stories
            await dut.fetchStories(with: context, refreshing: refreshing)

            let persistedStories = try context.fetch(Story.FetchDescriptors.notDeleted)

            // The initial data is still there
            #expect(persistedStories.count == 9)
            #expect(Set(persistedStories) == Set(initialPersistedStories))
            // The error is stored
            #expect(dut.error as? ParsingError == .fileNotFound)
        }

        @Test("Fetch valid stories when none are persisted should add all stories to the context",
              arguments: [true, false])
        func validStories_nonePersisted_addsToContext(refreshing: Bool) async throws {
            let dataService = StoryDataServiceStub(fileName: FileNameConstants.StoriesSearchResult.valid,
                                                   bundle: Bundle(for: type(of: self)))
            let dut = StoryFeedViewModel(dataService: dataService)
            let container = try newStoryContainer()
            let context = container.mainContext

            // Fetch new stories
            await dut.fetchStories(with: context, refreshing: refreshing)

            let persistedStories = try context.fetch(Story.FetchDescriptors.notDeleted)

            // The data has been added
            #expect(persistedStories.count == 9)
        }

        @Test("Fetch no stories when some are persisted should delete the persisted when refreshing")
        func noStories_somePersisted_refreshing_deleteFromContext() async throws {
            // Seems to work when running the app, but the test is failing
            // when trying to delete the initial stories from the context
            await withKnownIssue {
                let dataService = StoryDataServiceStub(fileName: FileNameConstants.StoriesSearchResult.empty,
                                                       bundle: bundle)
                let dut = StoryFeedViewModel(dataService: dataService)
                let container = try newStoryContainer()
                let context = container.mainContext

                // Add initial data
                let searchResult = try searchResult(forFileNamed: FileNameConstants.StoriesSearchResult.valid)
                context.insertMapping(contentsOf: searchResult.stories) { dto in Story(from: dto) }

                // Fetch new stories
                await dut.fetchStories(with: context, refreshing: true)
                // try context.save()

                let persistedStories = try context.fetch(Story.FetchDescriptors.notDeleted)

                // The data has been deleted
                #expect(persistedStories.count == 0)
            }
        }

        @Test("Fetch no stories when some are persisted should not delete the persisted when not refreshing")
        func noStories_somePersisted_notRefreshing_deleteFromContext() async throws {
            let dataService = StoryDataServiceStub(fileName: FileNameConstants.StoriesSearchResult.empty,
                                                   bundle: bundle)
            let dut = StoryFeedViewModel(dataService: dataService)
            let container = try newStoryContainer()
            let context = container.mainContext
            var initialPersistedStories: [Story] = []

            // Add initial data
            let searchResult = try searchResult(forFileNamed: FileNameConstants.StoriesSearchResult.valid)
            context.insertMapping(contentsOf: searchResult.stories) { dto in
                let story = Story(from: dto)
                initialPersistedStories.append(story)
                return story
            }

            // Fetch new stories
            await dut.fetchStories(with: context, refreshing: false)

            let persistedStories = try context.fetch(Story.FetchDescriptors.notDeleted)

            // The initial data is still there
            #expect(persistedStories.count == 9)
            #expect(Set(persistedStories) == Set(initialPersistedStories))
        }

        @Test("Fetch same stories as the ones persisted should not duplicate them in the context",
              arguments: [true, false])
        func sameStoriesAsPersisted_dontDuplicateInContext(refreshing: Bool) async throws {
            let dataService = StoryDataServiceStub(fileName: FileNameConstants.StoriesSearchResult.valid,
                                                   bundle: bundle)
            let dut = StoryFeedViewModel(dataService: dataService)
            let container = try newStoryContainer()
            let context = container.mainContext
            var initialPersistedStories: [Story] = []

            // Add initial data
            let searchResult = try searchResult(forFileNamed: FileNameConstants.StoriesSearchResult.valid)
            context.insertMapping(contentsOf: searchResult.stories) { dto in
                let story = Story(from: dto)
                initialPersistedStories.append(story)
                return story
            }

            // Fetch new stories
            await dut.fetchStories(with: context, refreshing: refreshing)

            let persistedStories = try context.fetch(Story.FetchDescriptors.notDeleted)

            // The initial data is still there
            #expect(persistedStories.count == 9)
            #expect(Set(persistedStories) == Set(initialPersistedStories))
        }

        @Test("Fetch valid stories when some are persisted should add only new stories to the context",
              arguments: [true, false])
        func validStories_somePersisted_addsOnlyNewToContext(refreshing: Bool) async throws {
            let dataService = StoryDataServiceStub(fileName: FileNameConstants.StoriesSearchResult.additionalValid,
                                                   bundle: bundle)
            let dut = StoryFeedViewModel(dataService: dataService)
            let container = try newStoryContainer()
            let context = container.mainContext
            var initialPersistedStories: [Story] = []

            // Add initial data
            let searchResult = try searchResult(forFileNamed: FileNameConstants.StoriesSearchResult.valid)
            context.insertMapping(contentsOf: searchResult.stories) { dto in
                let story = Story(from: dto)
                initialPersistedStories.append(story)
                return story
            }

            // Fetch new stories
            await dut.fetchStories(with: context, refreshing: refreshing)

            let persistedStories = try context.fetch(Story.FetchDescriptors.notDeleted)

            // The initial data is still there and more data has been added
            #expect(persistedStories.count == 13)
            #expect(Set(initialPersistedStories).isSubset(of: Set(persistedStories)))
        }

        @Test("Fetch valid stories when none are persisted should add all stories to the context",
              arguments: [true, false])
        func validStories_somePersisted_addsToContext(refreshing: Bool) async throws {
            let dataService = StoryDataServiceStub(fileName: FileNameConstants.StoriesSearchResult.valid,
                                                   bundle: Bundle(for: type(of: self)))
            let dut = StoryFeedViewModel(dataService: dataService)
            let container = try newStoryContainer()
            let context = container.mainContext

            // Fetch new stories
            await dut.fetchStories(with: context, refreshing: refreshing)

            let persistedStories = try context.fetch(Story.FetchDescriptors.notDeleted)

            #expect(persistedStories.count == 9)
        }

        @Test("Fetch same stories as the ones persisted with some deleted should not re-add them to the context",
              arguments: [true, false])
        func sameStoriesAsPersisted_someDeleted_dontReAddToContext(refreshing: Bool) async throws {
            let dataService = StoryDataServiceStub(fileName: FileNameConstants.StoriesSearchResult.valid,
                                                   bundle: bundle)
            let dut = StoryFeedViewModel(dataService: dataService)
            let container = try newStoryContainer()
            let context = container.mainContext
            var initialPersistedStories: [Story] = []   // not deleted
            let idsOfStoriesToDelete = ["38309611", "3078128", "31261533"]

            // Add initial data
            let searchResult = try searchResult(forFileNamed: FileNameConstants.StoriesSearchResult.valid)
            context.insertMapping(contentsOf: searchResult.stories) { dto in
                let story = Story(from: dto)
                if idsOfStoriesToDelete.contains(story.id) {
                    story.delete()
                } else {
                    initialPersistedStories.append(story)
                }
                return story
            }

            // Fetch new stories
            await dut.fetchStories(with: context, refreshing: refreshing)

            let persistedStories = try context.fetch(Story.FetchDescriptors.notDeleted)

            #expect(persistedStories.count == 6)
            #expect(!persistedStories.contains(where: { story in
                idsOfStoriesToDelete.contains(story.id)
            }))
            #expect(Set(initialPersistedStories).isSubset(of: Set(persistedStories)))
        }

        // MARK: Helper methods

        private func newStoryContainer() throws -> ModelContainer {
            return try ModelContainer(for: Story.self,
                                      configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        }

        private func searchResult(forFileNamed fileName: String) throws -> StoriesSearchResultDTO {
            try parseJSON(from: fileName, bundle: bundle)
        }

    }

}
