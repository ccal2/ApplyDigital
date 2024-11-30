//
//  Story.swift
//  ApplyDigital
//
//  Created by Carolina Lopes on 28/11/24.
//

import Foundation

struct Story: Identifiable, Codable {
    let id: Int
    let author: String?
    let createdAt: Date?
    let url: String?

    var title: String? {
        _title ?? _storyTitle
    }

    private let _title: String?
    private let _storyTitle: String?

    // swiftlint:disable identifier_name
    enum CodingKeys: String, CodingKey {
        case id = "story_id"
        case _title = "title"
        case _storyTitle = "story_title"
        case author
        case createdAt = "created_at"
        case url
    }
    // swiftlint:enable identifier_name

}

struct StoriesSearchResult: Codable {
    let stories: [Story]

    enum CodingKeys: String, CodingKey {
        case stories = "hits"
    }
}
