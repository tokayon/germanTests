//
//  Constants.swift
//  GermanTests
//
//  Created by Serge Sinkevych on 6/18/25.
//

import Foundation

struct Constants {
    static let questionsCount: Int = 33
    static let autoAdvancedDelay: TimeInterval = 1
    static let warningRemainingSeconds: Int = 60

    struct Settings {
        static let defaultTranslationLanguage: String = "en"
        static let defaultTestDuration: Int = 30 * 60 // in seconds
    }
    
}
