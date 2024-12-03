//
//  StoryDTO.swift
//  ApplyDigital
//
//  Created by Carolina Lopes on 28/11/24.
//

import Foundation

struct StoryDTO: Identifiable, Codable {
    let id: String
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
        case id = "objectID"
        case _title = "title"
        case _storyTitle = "story_title"
        case author
        case createdAt = "created_at"
        case url = "story_url"
    }
    // swiftlint:enable identifier_name

}

struct StoriesSearchResultDTO: Codable {
    let stories: [StoryDTO]

    enum CodingKeys: String, CodingKey {
        case stories = "hits"
    }
}
