//
//  QuestionListView.swift
//  GermanTests
//
//  Created by Serge Sinkevych on 6/5/25.
//

import SwiftUI
import AVFoundation
import UIKit

struct QuestionListView: View {
    @State var viewModel = QuestionViewModel()
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPickerPresented = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if let question = viewModel.currentQuestion {
                    questionView(for: question)
                } else {
                    ProgressView("Loading questions...")
                }
            }
            .navigationTitle("Exam")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.showTranslation.toggle()
                    }) {
                        Image(systemName: "globe")
                    }
                    .accessibilityLabel("Translate")
                }
            }
        }
    }
    
    private func questionView(for question: ExamQuestion) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(viewModel.showTranslation ? question.translated : question.original)
                .font(.system(size: 25, weight: .medium))
                .padding(.horizontal)
                .padding(.bottom)

            ScrollView {
                ForEach(question.answers) { answer in
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                borderColor(for: answer, in: question),
                                lineWidth: lineWidth(for: answer, in: question)
                            )
                            .background(Color.white) // Or your preferred background

                        HStack(spacing: 12) {
                            Circle()
                                .fill(dotColor(for: answer, in: question))
                                .frame(width: 10, height: 10)

                            Text(viewModel.showTranslation ? answer.translated : answer.original)
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.primary)

                            Spacer()
                        }
                        .padding()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.selectedAnswer = answer

                            if answer.id == question.correctAnswerId {
                                playSound(name: "success", fileExtension: "m4a")
                            } else {
                                vibrateWrongAnswer()
                                playSound(name: "fail", fileExtension: "mp3")
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                }
                .padding(.vertical, 5)
            }

            Spacer()

            titleView
            buttonsView
        }
        .padding(.horizontal)
    }
    
    private var titleView: some View {
        HStack {
            Spacer()
            Button(action: {
                isPickerPresented = true
            }) {
                HStack(spacing: 6) {
                    Text("Question \(viewModel.currentIndex + 1)")
                    Image(systemName: "chevron.down.circle.fill")
                }
                .font(.title3)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            }
            Spacer()
        }
        .sheet(isPresented: $isPickerPresented) {
            QuestionPickerView(
                viewModel: viewModel,
                onSelect: { index in
                    viewModel.currentIndex = index
                    viewModel.selectedAnswer = nil
                    isPickerPresented = false
                }
            )
        }
    }
    
    private var buttonsView: some View {
        HStack {
            Spacer()
            
            Button {
                viewModel.goBack()
            } label: {
                Text("Back")
                    .font(.system(size: 20, weight: .semibold))
            }
            .disabled(viewModel.currentIndex == 0)

            Spacer()

            // ✅ Reserve space and animate without jumping
            ZStack {
                correctImage
            }
            .font(.system(size: 40))
            .foregroundColor(iconColor)
            .opacity(viewModel.selectedAnswer != nil ? 1 : 0)
            .animation(.easeInOut, value: viewModel.selectedAnswer != nil)

            Spacer()

            Button {
                viewModel.goNext()
            } label: {
                Text("Next")
                    .font(.system(size: 20, weight: .semibold))
            }
            .disabled(viewModel.currentIndex == viewModel.questions.count - 1)

            Spacer()
        }
    }
    
    private func dotColor(for answer: ExamAnswer, in question: ExamQuestion) -> Color {
        guard viewModel.selectedAnswer != nil else {
            return .gray
        }
        return answer.id == question.correctAnswerId ? .green : .red
    }
    
    private func borderColor(for answer: ExamAnswer, in question: ExamQuestion) -> Color {
        guard let selected = viewModel.selectedAnswer else {
            return .gray // Default before selection
        }

        if answer == selected {
            return answer.id == question.correctAnswerId ? .green : .red
        }

        return .gray // Unselected answers stay gray
    }
    
    private func lineWidth(for answer: ExamAnswer, in question: ExamQuestion) -> CGFloat {
        guard let selected = viewModel.selectedAnswer, answer == selected else {
            return 1
        }
        
        return 3
    }
    
    private var iconColor: Color {
        guard let selected = viewModel.selectedAnswer,
              let correctId = viewModel.currentQuestion?.correctAnswerId else {
            return .gray
        }
        return selected.id == correctId ? .green : .red
    }
    
    private var correctImage: Image {
        guard let selected = viewModel.selectedAnswer,
              let correctId = viewModel.currentQuestion?.correctAnswerId else {
            return Image(systemName: "checkmark.circle.fill")
        }
        return selected.id == correctId ? Image(systemName: "checkmark.circle.fill") : Image(systemName: "xmark.circle.fill")
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
            print("❌ Sound file not found")
        }
    }
    
    private func vibrateWrongAnswer() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}

struct QuestionPickerView: View {
    var viewModel: QuestionViewModel
    let onSelect: (Int) -> Void
    
    var body: some View {
        NavigationStack {
            List(0..<viewModel.questions.count, id: \.self) { index in
                Button {
                    onSelect(index)
                } label: {
                    HStack {
                        Text("\(viewModel.questions[index].id)")
                        if index == viewModel.currentIndex {
                            Spacer()
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Select Question")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    QuestionListView()
}
