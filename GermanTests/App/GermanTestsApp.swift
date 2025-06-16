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
        // Set default language if not already set
        if UserDefaults.standard.string(forKey: "selectedLanguage") == nil {
            UserDefaults.standard.set(Language.en.rawValue, forKey: "selectedLanguage")
        }
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
