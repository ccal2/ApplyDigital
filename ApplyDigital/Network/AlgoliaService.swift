//
//  AlgoliaService.swift
//  ApplyDigital
//
//  Created by Carolina Lopes on 29/11/24.
//

import Foundation

protocol StoryDataService {
    @MainActor
    func fetchData<T: Codable>(from endpoint: AlgoliaEndpoint) async throws -> T
}

enum FetchError: Error {
    case badURL
    case invalidRequest
    case badRequest
    case failedToDecodeResponse
}

class AlgoliaService: StoryDataService {

    // MARK: - Properties

    @MainActor
    static let shared = AlgoliaService()

    // MARK: - Methods

    init() { }

    func fetchData<T: Codable>(from endpoint: AlgoliaEndpoint) async throws -> T {
        guard var url = URL(string: endpoint.urlString) else {
            throw FetchError.badURL
        }
        url.append(queryItems: endpoint.queryItems)

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw FetchError.badRequest
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        guard let decodedResponse = try? decoder.decode(T.self, from: data) else {
            throw FetchError.failedToDecodeResponse
        }

        return decodedResponse
    }

}
