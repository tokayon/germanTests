//
//  LanguageDropdownMenu.swift
//  GermanTests
//
//  Created by Serge Sinkevych on 6/15/25.
//

import Foundation
import SwiftUI


struct LanguageDropdownView: View {
    @State private var selectedLanguage: Language = .de
    @State private var showDropdown = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation {
                    showDropdown.toggle()
                }
            }) {
                Text(selectedLanguage.rawValue)
                    .font(.system(size: 28))
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }

            if showDropdown {
                VStack(spacing: 4) {
                    ForEach(Language.allCases.filter { $0 != selectedLanguage }, id: \.self) { language in
                        Button(action: {
                            withAnimation {
                                selectedLanguage = language
                                showDropdown = false
                            }
                        }) {
                            HStack {
                                Text(language.rawValue)
                                    .font(.system(size: 28))
                                Text(language.label)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                            .padding(.vertical, 4)
                            .padding(.horizontal)
                        }
                        .background(Color.white)
                        .cornerRadius(6)
                    }
                }
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding(.top, 4)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding()
    }
}
