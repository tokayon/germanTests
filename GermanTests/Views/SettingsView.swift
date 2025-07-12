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
    @StateObject private var settings = SettingsManager()
    @Environment(\.dismiss) private var dismiss

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // About Section
                Section(header: Text(Constants.Labels.about)) {
                    HStack {
                        Text(Constants.Labels.appVersion[safe: settings.selectedLanguage])
                        Spacer()
                        Text(appVersion)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Translation Section
                Section(header: Text(Constants.Labels.translation[safe: settings.selectedLanguage])) {
                    NavigationLink(destination: LanguageSelectionView()) {
                        HStack {
                            Text(Constants.Labels.prefTranslation[safe: settings.selectedLanguage])
                            Spacer()
                            Text(Language(from: settings.selectedLanguage).flag)
                        }
                    }
                }

                // Test Settings
                Section(header: Text(Constants.Labels.test[safe: settings.selectedLanguage])) {
                    Picker(Constants.Labels.testDuration[safe: settings.selectedLanguage], selection: settings.$testDuration) {
                        ForEach(TestDuration.allCases) { duration in
                            Text(duration.formatted).tag(duration.rawValue)
                        }
                    }
                }

                // Sound Toggle
                Section(header: Text(Constants.Labels.sounds[safe: settings.selectedLanguage])) {
                    Toggle(Constants.Labels.soundEffects[safe: settings.selectedLanguage], isOn: settings.$isSoundOn)
                }

                // Support / Say Thanks Section
                Section(header: Text(Constants.Labels.support[safe: settings.selectedLanguage])) {
                    Button(Constants.Labels.sayThanks[safe: settings.selectedLanguage]) {
                        openURL(Constants.Links.sayThanks)
                    }
                }

                // Legal Section
                Section(header: Text(Constants.Labels.legal)) {
                    NavigationLink(Constants.Labels.termsAndConditions) {
                        LegalWebView(title: Constants.Labels.termsAndConditions, urlString: Constants.Links.terms)
                    }
                    NavigationLink(Constants.Labels.privacyPolicy) {
                        LegalWebView(title: Constants.Labels.privacyPolicy, urlString: Constants.Links.policy)
                    }
                }
            }
            .navigationTitle(Constants.Labels.settings[safe: settings.selectedLanguage])
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
