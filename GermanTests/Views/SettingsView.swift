//
//  SettingsView.swift
//  GermanTests
//
//  Created by Serge Sinkevych on 6/16/25.
//

import Foundation
import SwiftUI

enum TestDuration: Int, CaseIterable, Identifiable {
    case minutes15 = 900 // in seconds
    case minutes30 = 1800
    case minutes45 = 2700
    case minutes60 = 3600
    case minutes90 = 5400

    var id: Int { rawValue }

    var formatted: String {
        String(format: "%02d:00", rawValue / 60)
    }
}

struct SettingsView: View {
    @AppStorage("selectedLanguage") private var selectedLanguage: String = Language.en.rawValue
    @AppStorage("testDuration") private var testDuration: Int = TestDuration.minutes30.rawValue
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Translation")) {
                    NavigationLink(destination: LanguageSelectionView()) {
                        HStack {
                            Text("Preferred Translation")
                            Spacer()
                            Text(Language(from: selectedLanguage).flag)
                        }
                    }
                }
                
                Section(header: Text("Test")) {
                    Picker("Test Duration", selection: $testDuration) {
                        ForEach(TestDuration.allCases) { duration in
                            Text(duration.formatted).tag(duration.rawValue)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .imageScale(.medium)
                            .padding(8)
                    }
                }
            }
        }
    }
}
