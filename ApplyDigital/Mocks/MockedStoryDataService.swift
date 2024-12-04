//
//  MockedStoryDataService.swift
//  ApplyDigital
//
//  Created by Carolina Lopes on 04/12/24.
//

class MockedStoryDataService: StoryDataService {

    // MARK: - Properties

    var fileName: String

    // MARK: - Methods

    init(fileName: String = "mocked_stories.json") {
        self.fileName = fileName
    }

    func fetchData<T: Codable>(from endpoint: AlgoliaEndpoint) async throws -> T {
        try parseJSON(from: fileName)
    }

}
