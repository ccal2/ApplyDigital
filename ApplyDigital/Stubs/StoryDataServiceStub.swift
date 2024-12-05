//
//  StoryDataServiceStub.swift
//  ApplyDigital
//
//  Created by Carolina Lopes on 04/12/24.
//

import Foundation

class StoryDataServiceStub: StoryDataService {

    // MARK: - Properties

    var fileName: String
    var bundle: Bundle

    // MARK: - Methods

    init(fileName: String = "stories_sample.json", bundle: Bundle = Bundle.main) {
        self.fileName = fileName
        self.bundle = bundle
    }

    func fetchData<T: Codable>(from endpoint: AlgoliaEndpoint) async throws -> T {
        try parseJSON(from: fileName, bundle: bundle)
    }

}
