//
//  GermanTestsApp.swift
//  GermanTests
//
//  Created by Serge Sinkevych on 6/5/25.
//

import SwiftUI

@main
struct GermanTestsApp: App {
    init() {
        SettingsManager.registerDefaults()
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
