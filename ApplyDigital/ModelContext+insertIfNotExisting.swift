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

        let elementCount = try? fetchCount(FetchDescriptor<Story>(predicate: #Predicate<Story> { element in
            element.id == storyID
        }))

        guard elementCount ?? 0 == 0 else {
            return
        }

        insert(story)
    }

}
