//
//  MainTabView.swift
//  GermanTests
//
//  Created by Serge Sinkevych on 6/8/25.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    @StateObject private var settings = SettingsManager()

    var body: some View {
        TabView {
            PracticeView()
                .tabItem {
                    Label(Constants.Labels.practice[safe: settings.selectedLanguage], systemImage: "book.fill")
                }

            TestStartView()
                .tabItem {
                    Label(Constants.Labels.test[safe: settings.selectedLanguage], systemImage: "checkmark.shield.fill")
                }
        }
    }
}
