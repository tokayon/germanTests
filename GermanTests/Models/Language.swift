//
//  Language.swift
//  GermanTests
//
//  Created by Serge Sinkevych on 6/16/25.
//

import Foundation

enum Language: String, CaseIterable, Identifiable {
    case de, en, ru, uk
    
    init(from string: String?) {
        if let string {
            self = Language(rawValue: string) ?? .de
        } else {
            self = .de
        }
    }

    var id: String { rawValue }

    var flag: String {
        switch self {
        case .de: "🇩🇪"
        case .en: "🇬🇧"
        case .ru: "🇷🇺"
        case .uk: "🇺🇦"
        }
    }

    var label: String {
        switch self {
        case .de: "German"
        case .en: "English"
        case .ru: "Russian"
        case .uk: "Ukrainian"
        }
    }
}
