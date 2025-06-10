//
//  QuestionListView.swift
//  GermanTests
//
//  Created by Serge Sinkevych on 6/5/25.
//

import SwiftUI
import AVFoundation
import Foundation
import UIKit

enum ExamMode: Equatable {
    case practice
    case exam(Int)
}

struct QuestionListView: View {
    
    private struct Constants {
        static let autoAdvancedDelay: TimeInterval = 1
        static let correctAnswersToPass: Int = 17
        static let remainingSeconds = 30*60
        static let warningRemainingSeconds: Int = 60
    }
    
    @State var viewModel: QuestionViewModel
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPickerPresented = false
    @State private var correctAnswers = 0
    @State private var remainingSeconds = Constants.remainingSeconds
    @State private var timerColor: Color = .blue
    @State private var timer: Timer?
    @State private var isAdvancing: Bool = false
    
    private let sessionID: UUID
    let mode: ExamMode
    var onExamFinished: ((_ correct: Int, _ total: Int, _ passed: Bool) -> Void)? = nil

    init(mode: ExamMode = .practice, sessionID: UUID = UUID(), onExamFinished: ((_ correct: Int, _ total: Int, _ passed: Bool) -> Void)? = nil) {
        _viewModel = State(wrappedValue: QuestionViewModel(mode: mode))
        self.mode = mode
        self.sessionID = sessionID
        self.onExamFinished = onExamFinished
    }
    
    private var timerView: some View {
        Text("⏱ \(formattedTime)")
            .font(.title)
            .foregroundColor(timerColor)
            .padding()
    }
    
    private var formattedTime: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if let question = viewModel.currentQuestion {
                    questionView(for: question, mode: mode)
                } else {
                    ProgressView("Loading questions...")
                }
            }
            .navigationTitle(mainTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.showTranslation.toggle()
                    }) {
                        Image(systemName: "globe")
                            .padding(12) // Expand the tappable area
                            .contentShape(Rectangle()) // Ensure tap is detected on padding too
                    }
                    .accessibilityLabel("Translate")
                }
            }
            .onAppear {
                if case .exam = mode {
                    startTimer()
                }
            }
        }
        .id(sessionID)
    }
    
    private var mainTitle: String {
        switch mode {
        case .practice:
            "Studie"
        case .exam(let int):
            "Prüfung \(int)"
        }
    }
    
    @ViewBuilder private func questionView(for question: ExamQuestion, mode: ExamMode) -> some View {
        switch mode {
        case .practice:
            VStack(alignment: .leading, spacing: 0) {
                Text(viewModel.showTranslation ? question.translated : question.original)
                    .font(.system(size: 25, weight: .medium))
                    .padding(.horizontal)
                    .padding(.bottom)

                answersView(for: question)

                Spacer()
                correctImageView
                buttonsView
            }
            .padding(.horizontal)
        case .exam:
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Spacer()
                    timerView
                    Spacer()
                }
                
                Text(viewModel.showTranslation ? question.translated : question.original)
                    .font(.system(size: 25, weight: .medium))
                    .padding(.horizontal)
                    .padding(.bottom)

                answersView(for: question)

                Spacer()
                                
                HStack {
                    Spacer()
                    Text("Frage \(viewModel.currentIndex+1) von \(viewModel.questions.count)")
                    correctImage
                    .font(.system(size: 20))
                    .opacity(viewModel.selectedAnswer != nil ? 1 : 0)
                    .foregroundColor(iconColor)
                    Spacer()
                }
                .padding()
                
                examButtonView
            }
            .padding(.horizontal)
        }
    }
    
    private func answersView(for question: ExamQuestion) -> some View {
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
                            correctAnswers += 1
                            playSound(name: "success", fileExtension: "m4a")
                        } else {
                            vibrateWrongAnswer()
                            playSound(name: "error", fileExtension: "mp3")
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            }
            .padding(.vertical, 5)
        }
    }
    
    private var questionPickerView: some View {
        HStack {
            Spacer()
            Button(action: {
                isPickerPresented = true
            }) {
                HStack(spacing: 6) {
                    Text("Frage \(viewModel.currentIndex + 1)")
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
            
            Button(action: {
                viewModel.goBack()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .padding(8)
                    .contentShape(Rectangle()) // Expand tappable area
            }
            .accessibilityLabel("Zurück")
            .disabled(viewModel.currentIndex == 0)
            
            Spacer()
            
            questionPickerView

            Spacer()

            Button(action: {
                viewModel.goNext()
            }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .semibold))
                    .padding(8)
                    .contentShape(Rectangle())
            }
            .accessibilityLabel("Weiter")
            .disabled(viewModel.currentIndex == viewModel.questions.count - 1)

            Spacer()
        }
        .padding()
    }
    
    private var examButtonView: some View {
        HStack {
            Spacer()
            Button(action: {
                viewModel.goNext()
            }) {
                Image(systemName: "arrowshape.forward.circle.fill")
                    .font(.system(size: 50, weight: .semibold))
                    .padding(8)
                    .contentShape(Rectangle())
            }
            .accessibilityLabel("Weiter")
            .disabled(isExamButtonDisabled)

            Spacer()
        }
        .padding()
    }
    
    private var isExamButtonDisabled: Bool {
        viewModel.currentIndex == viewModel.questions.count - 1 ||
        viewModel.selectedAnswer == nil
    }
    
    private var correctImageView: some View {
        ZStack {
            HStack {
                Spacer()
                correctImage
                Spacer()
            }
        }
        .font(.system(size: 40))
        .foregroundColor(iconColor)
        .opacity(viewModel.selectedAnswer != nil ? 1 : 0)
        .animation(.easeInOut(duration: 0.1), value: viewModel.selectedAnswer != nil)
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
    
    private func advanceExam() {
        if viewModel.currentIndex < viewModel.questions.count - 1 {
            viewModel.currentIndex += 1
            viewModel.selectedAnswer = nil
            isAdvancing = false
        } else {
            finishExam()
        }
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingSeconds > 0 {
                remainingSeconds -= 1
            } else {
                finishExam()
            }
            
            if remainingSeconds < Constants.warningRemainingSeconds {
                timerColor = .red
            }
        }
    }

    private func finishExam() {
        timer?.invalidate()
        let passed = correctAnswers >= Constants.correctAnswersToPass
        if !passed {
            playSound(name: "fail", fileExtension: "mp3")
        }
        onExamFinished?(correctAnswers, viewModel.questions.count, passed)
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
            .navigationTitle("Frage auswählen")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    QuestionListView()
}
