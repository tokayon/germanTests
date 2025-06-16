//
//  SettingsView.swift
//  GermanTests
//
//  Created by Serge Sinkevych on 6/16/25.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedLanguage") private var selectedLanguage: String = Language.en.rawValue

    var body: some View {
        NavigationStack {
            Form {
                NavigationLink(destination: LanguageSelectionView()) {
                    HStack {
                        Text("Preferred Translation")
                        Spacer()
                        Text(Language(from: selectedLanguage).flag)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
