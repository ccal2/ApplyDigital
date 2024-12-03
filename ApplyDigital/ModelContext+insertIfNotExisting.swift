//
//  ModelContext+insertIfNotExisting.swift
//  ApplyDigital
//
//  Created by Carolina Lopes on 02/12/24.
//

import SwiftData
import Foundation

extension ModelContext {

    func insertIfNotExisting(_ story: Story) {
        let storyID = story.id

        let existingElement = try? fetch(FetchDescriptor<Story>(predicate: #Predicate<Story> { element in
            element.id == storyID
        })).first

        guard existingElement == nil else {
            return
        }

        insert(story)
    }

}
