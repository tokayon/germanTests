//
//  MainTabView.swift
//  GermanTests
//
//  Created by Serge Sinkevych on 6/8/25.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            PracticeView()
                .tabItem {
                    Label("Studie", systemImage: "book.fill")
                }

            ExamStartView()
                .tabItem {
                    Label("Prüfung", systemImage: "checkmark.square.fill")
                }
        }
    }
}
