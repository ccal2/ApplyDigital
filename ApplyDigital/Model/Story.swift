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

    // MARK: - Properties

    @Attribute(.unique) private(set) var id: String
    private(set) var author: String?
    private(set) var createdAt: Date?
    private(set) var url: String?
    private(set) var title: String?
    private(set) var isDeleted: Bool = false

    // MARK: - Methods

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

    func delete() {
        isDeleted = true
    }

}

extension Story {

    enum Predicates {
        static let all = #Predicate<Story> { _ in true }
        static let notDeleted = #Predicate<Story> { story in !story.isDeleted }
        static let deleted = #Predicate<Story> { story in story.isDeleted }
    }

    enum FetchDescriptors {
        static let all = FetchDescriptor<Story>(predicate: Story.Predicates.all)
        static let notDeleted = FetchDescriptor<Story>(predicate: Story.Predicates.notDeleted)
        static let deleted = FetchDescriptor<Story>(predicate: Story.Predicates.deleted)
    }

}
