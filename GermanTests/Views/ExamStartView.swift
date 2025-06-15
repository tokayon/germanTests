//
//  ExamStartView.swift
//  GermanTests
//
//  Created by Serge Sinkevych on 6/8/25.
//

import Foundation
import SwiftUI
import AVFoundation

struct ExamStartView: View {
    
    private struct Constants {
        static let questionsCount: Int = 33
    }
    
    @State private var isExamStarted = false
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
            .navigationTitle("Test")
            .navigationDestination(isPresented: $isExamStarted) {
                QuestionListView(mode: .exam(Constants.questionsCount), sessionID: sessionID) { correct, total, passed, time in
                    self.resultData = ExamResultData(correct: correct, total: total, passed: passed, time: time)
                    self.isExamStarted = false
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
        VStack(spacing: 24) {
            Spacer()
            Text(result.passed ? "🎉 Congrats!" : "❌ Failed")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)

            Text("Correct: \(result.correct) of \(result.total)")
                .font(.title3)
                .padding(.vertical)
                        
            Text("Time: \(result.time / 60) min \(result.time % 60) sec")

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
