//
//  ApplyDigitalApp.swift
//  ApplyDigital
//
//  Created by Carolina Lopes on 28/11/24.
//

import SwiftUI

@main
struct ApplyDigitalApp: App {
    var body: some Scene {
        WindowGroup {
            StoryFeedView()
                .environment(StoryFeedViewModel())
        }
    }
}
