//
//  MainTabView.swift
//  GermanTests
//
//  Created by Serge Sinkevych on 6/8/25.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    @AppStorage("selectedLanguage") private var selectedLanguage: String = Language.en.rawValue

    var body: some View {
        TabView {
            PracticeView()
                .tabItem {
                    Label(Constants.Labels.practice[safe: selectedLanguage], systemImage: "book.fill")
                }

            TestStartView()
                .tabItem {
                    Label(Constants.Labels.test[safe: selectedLanguage], systemImage: "checkmark.shield.fill")
                }
        }
    }
}
