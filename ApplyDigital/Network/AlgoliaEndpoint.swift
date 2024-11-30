//
//  AlgoliaEndpoint.swift
//  ApplyDigital
//
//  Created by Carolina Lopes on 29/11/24.
//

import Foundation

enum AlgoliaEndpoint {
    static let baseUSL = "https://hn.algolia.com/api/v1"

    case latestStories(query: String? = "mobile")

    var urlString: String {
        switch self {
        case .latestStories:
            return "\(Self.baseUSL)/search_by_date"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case let .latestStories(query):
            var items: [URLQueryItem] = []

            if let query { items.append(URLQueryItem(name: "query", value: query)) }

            return items
        }
    }

}
