//
//  ProductionApp.swift
//  ApplyDigital
//
//  Created by Carolina Lopes on 05/12/24.
//

import SwiftData
import SwiftUI

struct ProductionApp: App {
    var body: some Scene {
        WindowGroup {
            StoryFeedView()
                .environment(StoryFeedViewModel())
        }
        .modelContainer(for: Story.self)
    }
}
