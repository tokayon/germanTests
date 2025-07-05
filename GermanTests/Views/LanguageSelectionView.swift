//
//  LanguageSelectionView.swift
//  GermanTests
//
//  Created by Serge Sinkevych on 6/16/25.
//

import Foundation
import SwiftUI

struct LanguageSelectionView: View {
    @StateObject private var settings = SettingsManager()

    var body: some View {
        List(Language.allCases.filter { $0 != .de }) { lang in
            Button(action: {
                settings.selectedLanguage = lang.rawValue
            }) {
                HStack {
                    Text(lang.flag)
                    Text(lang.label)

                    Spacer()
                    if lang.rawValue == settings.selectedLanguage {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .navigationTitle(Constants.Labels.chooseLanguage[safe: settings.selectedLanguage])
    }
}
