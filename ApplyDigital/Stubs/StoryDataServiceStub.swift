//
//  StoryDataServiceStub.swift
//  ApplyDigital
//
//  Created by Carolina Lopes on 04/12/24.
//

class StoryDataServiceStub: StoryDataService {

    // MARK: - Properties

    var fileName: String

    // MARK: - Methods

    init(fileName: String = "stories_sample.json") {
        self.fileName = fileName
    }

    func fetchData<T: Codable>(from endpoint: AlgoliaEndpoint) async throws -> T {
        try parseJSON(from: fileName)
    }

}
