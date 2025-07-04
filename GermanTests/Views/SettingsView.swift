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
    @AppStorage("isSoundOn") private var isSoundOn: Bool = true

    @Environment(\.dismiss) private var dismiss

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // About Section
                Section(header: Text("About")) {
                    HStack {
                        Text("App Version")
                        Spacer()
                        Text(appVersion)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Translation Section
                Section(header: Text(Constants.Labels.translation[safe: selectedLanguage])) {
                    NavigationLink(destination: LanguageSelectionView()) {
                        HStack {
                            Text(Constants.Labels.prefTranslation[safe: selectedLanguage])
                            Spacer()
                            Text(Language(from: selectedLanguage).flag)
                        }
                    }
                }

                // Test Settings
                Section(header: Text(Constants.Labels.test[safe: selectedLanguage])) {
                    Picker(Constants.Labels.testDuration[safe: selectedLanguage], selection: $testDuration) {
                        ForEach(TestDuration.allCases) { duration in
                            Text(duration.formatted).tag(duration.rawValue)
                        }
                    }
                }

                // Sound Toggle
                Section(header: Text("Sound")) {
                    Toggle("Sound Effects", isOn: $isSoundOn)
                }

                // Support / Say Thanks Section
                Section(header: Text("Support")) {
                    Button("Say Thanks") {
                        openURL("https://www.tokayonapps.com/say-thanks/")
                    }
                }

                // Legal Section
                Section(header: Text("Legal")) {
                    NavigationLink("Terms and Conditions") {
                        LegalWebView(title: "Terms and Conditions", urlString: "https://example.com/terms")
                    }
                    NavigationLink("Privacy Policy") {
                        LegalWebView(title: "Privacy Policy", urlString: "https://example.com/privacy")
                    }
                }
            }
            .navigationTitle(Constants.Labels.settings[safe: selectedLanguage])
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
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}
