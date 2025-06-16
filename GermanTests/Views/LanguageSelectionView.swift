//
//  LanguageSelectionView.swift
//  GermanTests
//
//  Created by Serge Sinkevych on 6/16/25.
//

import Foundation
import SwiftUI

struct LanguageSelectionView: View {
    @AppStorage("selectedLanguage") private var selectedLanguage: String = Language.en.rawValue

    var body: some View {
        List(Language.allCases.filter { $0 != .de }) { lang in
            Button(action: {
                selectedLanguage = lang.rawValue
            }) {
                HStack {
                    Text(lang.label)
                    Spacer()
                    Text(lang.flag)
                    if lang.rawValue == selectedLanguage {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .navigationTitle("Choose Language")
    }
}
