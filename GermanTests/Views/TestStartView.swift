//
//  TestStartView.swift
//  GermanTests
//
//  Created by Serge Sinkevych on 6/8/25.
//

import Foundation
import SwiftUI
import AVFoundation

struct TestStartView: View {
    @AppStorage("selectedLanguage") private var selectedLanguage: String = Language.en.rawValue

    @State private var isTestStarted = false
    @State private var showResult = false
    @State private var resultData: ExamResultData? = nil
    @State private var sessionID = UUID()
    @State private var audioPlayer: AVAudioPlayer?
    
    struct ExamResultData: Identifiable {
        let id = UUID()
        let correct: Int
        let total: Int
        let passed: Bool
        let time: Int
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

                Button(action: {
                    isTestStarted = true
                }) {
                    Text(Constants.Labels.start[safe: selectedLanguage])
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
            .navigationTitle(Constants.Labels.test[safe: selectedLanguage])
            .fullScreenCover(isPresented: $isTestStarted, onDismiss: {
                // Optional logic after dismiss
            }) {
                let onCancel: () -> Void = {
                    self.isTestStarted = false
                }
                
                return QuestionListView(mode: .test(Constants.questionsCount), sessionID: sessionID, onCancel: onCancel) { correct, total, passed, time in
                    self.resultData = ExamResultData(correct: correct, total: total, passed: passed, time: time)
                    self.isTestStarted = false
                    self.sessionID = UUID()
                    
                    // Play appropriate sound
                    if passed {
                        playSound(name: "wow", fileExtension: "mp3")
                    } else {
                        playSound(name: "fail", fileExtension: "mp3")
                    }
                }
            }
            .sheet(item: $resultData) { result in
                examResultSheet(result: result)
            }
        }
    }
    
    private func examResultSheet(result: ExamResultData) -> some View {
        VStack(spacing: 28) {
            Spacer()
            
            // Header: Icon + Result Title
            VStack(spacing: 12) {
                Image(systemName: result.passed ? "checkmark.seal.fill" : "xmark.octagon.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 72, height: 72)
                    .foregroundColor(result.passed ? .green : .red)
                
                Text(result.passed
                     ? "🎉 \(Constants.Labels.congrats[safe: selectedLanguage])!"
                     : "❌ \(Constants.Labels.failed[safe: selectedLanguage])")
                .font(.largeTitle.weight(.bold))
                .multilineTextAlignment(.center)
            }
            
            // Stats: Correct Answers and Time
            VStack(spacing: 12) {
                Label {
                    Text("\(Constants.Labels.correct[safe: selectedLanguage]): \(result.correct) \(Constants.Labels.of[safe: selectedLanguage]) \(result.total)")
                } icon: {
                    Image(systemName: "checkmark.circle")
                }
                .font(.title3)
                .foregroundColor(.primary)
                
                Label {
                    Text("\(Constants.Labels.time[safe: selectedLanguage]): \(result.time / 60) \(Constants.Labels.min[safe: selectedLanguage]) \(result.time % 60) \(Constants.Labels.seconds[safe: selectedLanguage])")
                } icon: {
                    Image(systemName: "clock")
                }
                .font(.title3)
                .foregroundColor(.secondary)
            }
            
            // OK Button
            Button(action: {
                resultData = nil
            }) {
                Text("OK")
                    .font(.system(size: 20, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(result.passed ? Color.green : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal, 24)
    }
    
    private func playSound(name: String, fileExtension: String) {
        if let url = Bundle.main.url(forResource: name, withExtension: fileExtension) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("❌ Failed to play sound: \(error.localizedDescription)")
            }
        } else {
            print("❌ Sound file \(name).\(fileExtension) not found")
        }
    }
}
