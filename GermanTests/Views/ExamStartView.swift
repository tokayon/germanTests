//
//  ExamStartView.swift
//  GermanTests
//
//  Created by Serge Sinkevych on 6/8/25.
//

import Foundation
import SwiftUI

struct ExamStartView: View {
    
    private struct Constants {
        static let questionsCount: Int = 33
    }
    
    @State private var isExamStarted = false
    @State private var showResult = false
    @State private var resultData: ExamResultData? = nil
    @State private var sessionID = UUID()
    
    struct ExamResultData: Identifiable {
        let id = UUID()
        let correct: Int
        let total: Int
        let passed: Bool
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                
                Image("exam")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.horizontal)

                Text("Willkommen zum Prüfung")
                    .font(.title)
                    .padding()

                Button(action: {
                    isExamStarted = true
                }) {
                    Text("Start")
                        .font(.system(size: 24, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding()

                Spacer()
            }
            .navigationTitle("Prüfung")
            .navigationDestination(isPresented: $isExamStarted) {
                QuestionListView(mode: .exam(Constants.questionsCount), sessionID: sessionID) { correct, total, passed in
                    self.resultData = ExamResultData(correct: correct, total: total, passed: passed)
                    self.isExamStarted = false
                    self.sessionID = UUID()
                }
            }
            .sheet(item: $resultData) { result in
                examResultSheet(result: result)
            }
        }
    }
    
    private func examResultSheet(result: ExamResultData) -> some View {
        VStack(spacing: 24) {
            Spacer()
            Text(result.passed ? "🎉 Glückwunsch!" : "❌ Leider nicht bestanden")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)

            Text("Ergebnis: \(result.correct) von \(result.total) richtig")
                .font(.title3)

            Button("OK") {
                resultData = nil
            }
            .font(.system(size: 20, weight: .semibold))
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal)
            Spacer()
        }
    }
}
