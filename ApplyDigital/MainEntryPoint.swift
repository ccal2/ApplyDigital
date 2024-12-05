//
//  MainEntryPoint.swift
//  ApplyDigital
//
//  Created by Carolina Lopes on 28/11/24.
//

import SwiftUI

@main
struct MainEntryPoint {

    static func main() {
        if Self.isProduction {
            ProductionApp.main()
        } else {
            TestApp.main()
        }
    }

    private static var isProduction: Bool {
        return ProcessInfo.processInfo.environment["isTesting"] == "YES"
    }

}
