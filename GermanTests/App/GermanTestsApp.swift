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
        if UserDefaults.standard.string(forKey: "selectedLanguage") == nil {
            UserDefaults.standard.set(Constants.Settings.defaultTranslationLanguage, forKey: "selectedLanguage")
        }
        if UserDefaults.standard.integer(forKey: "testDuration") == 0 {
            UserDefaults.standard.set(Constants.Settings.defaultTestDuration, forKey: "testDuration")
        }
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
