//
//  Story.swift
//  ApplyDigital
//
//  Created by Carolina Lopes on 02/12/24.
//

import Foundation
import SwiftData

@Model
class Story {
    @Attribute(.unique) var id: String
    var author: String?
    var createdAt: Date?
    var url: String?
    var title: String?

    init(id: String, author: String? = nil, createdAt: Date? = nil, url: String? = nil, title: String? = nil) {
        self.id = id
        self.author = author
        self.createdAt = createdAt
        self.url = url
        self.title = title
    }

    convenience init(from dto: StoryDTO) {
        self.init(id: dto.id,
                  author: dto.author,
                  createdAt: dto.createdAt,
                  url: dto.url,
                  title: dto.title)
    }

}
