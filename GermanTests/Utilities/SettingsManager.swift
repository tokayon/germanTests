//
//  SettingsManager.swift
//  GermanTests
//
//  Created by Serge Sinkevych on 7/5/25.
//

import Foundation
import SwiftUI

final class SettingsManager: ObservableObject {
    @AppStorage("testDuration") var testDuration: Int = 1800
    @AppStorage("selectedLanguage") var selectedLanguage: String = Language.en.rawValue
    @AppStorage("isSoundOn") var isSoundOn: Bool = true
    
    static func registerDefaults() {
        UserDefaults.standard.register(defaults: [
            "testDuration": Constants.Settings.defaultTestDuration,
            "selectedLanguage": Constants.Settings.defaultTranslationLanguage,
            "isSoundOn": true
        ])
    }
}
