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

enum TestMode: Equatable {
    case practice
    case test(Int)
}

struct QuestionListView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("testDuration") private var testDuration: Int = 1800
    @AppStorage("selectedLanguage") private var selectedLanguage: String = Language.en.rawValue
    @AppStorage("isSoundOn") private var isSoundOn: Bool = true

    @State var viewModel: QuestionViewModel
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPickerPresented = false
    @State private var correctAnswers = 0
    @State private var timerColor: Color = .blue
    @State private var timer: Timer?
    @State private var showSettings = false
    @State private var remainingSeconds: Int = 1800
    @State private var showExitAlert = false

    private let sessionID: UUID
    let mode: TestMode
    var onTestFinished: ((_ correct: Int, _ total: Int, _ passed: Bool, _ time: Int) -> Void)? = nil
    let onCancel: (() -> Void)?

    init(mode: TestMode = .practice, sessionID: UUID = UUID(), onCancel: (() -> Void)? = nil, onTestFinished: ((_ correct: Int, _ total: Int, _ passed: Bool, _ time: Int) -> Void)? = nil) {
        _viewModel = State(wrappedValue: QuestionViewModel(mode: mode))
        self.mode = mode
        self.sessionID = sessionID
        self.onCancel = onCancel
        self.onTestFinished = onTestFinished
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
                    ProgressView(Constants.Labels.loadingQuestions[safe: selectedLanguage])
                }
            }
            .navigationTitle(mainTitle)
            .toolbar {
                if case .practice = mode {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            showSettings = true
                        } label: {
                            Image(systemName: "gear")
                                .imageScale(.large)
                                .padding(8)
                        }
                    }
                } else {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            showExitAlert = true
                        } label: {
                            Label("Exit", systemImage: "xmark")
                                .labelStyle(.iconOnly)
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.showTranslation.toggle()
                    }) {
                        Text(viewModel.selectedLanguage.flag)
                            .font(.title3)
                            .padding(8)
                    }
                }
            }
            .onAppear {
                remainingSeconds = testDuration
                if case .test = mode {
                    startTimer()
                }
            }
            .onChange(of: testDuration) {
                remainingSeconds = testDuration
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .alert(Constants.Labels.stopTestAlert[safe: selectedLanguage], isPresented: $showExitAlert) {
                Button(Constants.Labels.cancel[safe: selectedLanguage], role: .cancel) { }
                Button(Constants.Labels.stopTest[safe: selectedLanguage], role: .destructive) {
                    onCancel?()
                    dismiss()
                }
            } message: {
                Text(Constants.Labels.noProgress[safe: selectedLanguage])
            }
        }
        .id(sessionID)
    }
    
    private var mainTitle: String {
        switch mode {
        case .practice:
            Constants.Labels.practice[safe: selectedLanguage]
        case .test(let int):
            "\(Constants.Labels.test[safe: selectedLanguage]) \(int)"
        }
    }
    
    @ViewBuilder private func questionView(for question: ExamQuestion, mode: TestMode) -> some View {
        switch mode {
        case .practice:
            VStack(alignment: .leading, spacing: 0) {
                ScrollView{
                    
                    if let image = question.image {
                        HStack {
                            Spacer()
                            Image(image)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(15)
                                .padding()
                            Spacer()
                        }
                    }
                    
                    Text(questionTitle(id: question.id))
                        .font(.title)
                        .padding(.bottom)
                    Text(question.translations[viewModel.selectedLanguage.rawValue] ?? "")
                        .font(.system(size: 20, weight: .medium))
                        .padding(.bottom)
                    
                    answersView(for: question)
                    
                }
                Spacer()
                correctImageView
                buttonsView
            }
            .padding(.horizontal)
        case .test:
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Spacer()
                    timerView
                    Spacer()
                }
                
                ScrollView {
                    if let image = question.image {
                        HStack {
                            Spacer()
                            Image(image)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(15)
                                .padding()
                            Spacer()
                        }
                    }
                    
                    Text(question.translations[viewModel.selectedLanguage.rawValue] ?? "")
                        .font(.system(size: 20, weight: .medium))
                        .padding(.bottom)
                    
                    answersView(for: question)
                    
                }
                Spacer()
                                
                HStack {
                    Spacer()
                    Text("\(Constants.Labels.question[safe: selectedLanguage]) \(viewModel.currentIndex+1) \(Constants.Labels.of[safe: selectedLanguage]) \(viewModel.questions.count)")
                    correctImage
                    .font(.system(size: 20))
                    .opacity(viewModel.selectedAnswer != nil ? 1 : 0)
                    .foregroundColor(iconColor)
                    Spacer()
                }
                
                continueButtonView
            }
            .padding(.horizontal)
        }
    }
    
    private func answersView(for question: ExamQuestion) -> some View {
        //ScrollView {
            ForEach(question.answers) { answer in
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            borderColor(for: answer, in: question),
                            lineWidth: lineWidth(for: answer, in: question)
                        )
                        .background(Color(uiColor: .systemBackground))
                    
                    HStack(spacing: 12) {
                        Circle()
                            .fill(dotColor(for: answer, in: question))
                            .frame(width: 10, height: 10)
                        
                        Text(answer.translations[viewModel.selectedLanguage.rawValue] ?? "")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    .padding()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if case .test = mode, viewModel.selectedAnswer != nil {
                            return
                        }
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
        //}
    }
    
    private func questionTitle(id: String) -> String {
        if viewModel.showTranslation {
            return "\(Constants.Labels.question[safe: selectedLanguage]) \(id)"
        } else {
            return "Frage \(id)"
        }
    }
    
    private var questionPickerView: some View {
        HStack {
            Spacer()
            Button(action: {
                isPickerPresented = true
            }) {
                HStack(spacing: 6) {
                    Text("\(Constants.Labels.question[safe: selectedLanguage]) \(viewModel.currentIndex + 1)")
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
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    private var continueButtonView: some View {
        HStack {
            Spacer()
            Button(action: {
                continueTest()
            }) {
                Image(systemName: "arrowshape.forward.circle.fill")
                    .font(.system(size: 50, weight: .semibold))
                    .padding(8)
                    .contentShape(Rectangle())
            }
            .accessibilityLabel("Weiter")
            .disabled(isContinueButtonEnabled)

            Spacer()
        }
    }
    
    private var isContinueButtonEnabled: Bool {
        viewModel.currentIndex == viewModel.questions.count ||
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
        .font(.system(size: 20))
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
        guard isSoundOn else { return }
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
    
    private func continueTest() {
        if viewModel.currentIndex < viewModel.questions.count - 1 {
            viewModel.currentIndex += 1
            viewModel.selectedAnswer = nil
        } else {
            finishTest()
        }
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingSeconds > 0 {
                remainingSeconds -= 1
            } else {
                finishTest()
            }
            
            if remainingSeconds < Constants.warningRemainingSeconds {
                timerColor = .red
            }
        }
    }

    private func finishTest() {
        timer?.invalidate()
        let passed = correctAnswers > viewModel.questions.count / 2
        onTestFinished?(correctAnswers, viewModel.questions.count, passed, testDuration - remainingSeconds)
    }
}

struct QuestionPickerView: View {
    @AppStorage("selectedLanguage") private var selectedLanguage: String = Language.en.rawValue

    var viewModel: QuestionViewModel
    let onSelect: (Int) -> Void
    @State private var digitInput = ""
    
    // Filter questions by their ID (as a String) containing the digit input
    private var filteredQuestions: [ExamQuestion] {
        if digitInput.isEmpty {
            return viewModel.questions
        } else {
            return viewModel.questions.filter {
                String($0.id).contains(digitInput)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Search Display
                HStack {
                    Text("\(Constants.Labels.search[safe: selectedLanguage]): \(digitInput)")
                        .font(.title3)
                        .padding(.leading)
                    Spacer()
                    Button {
                        if !digitInput.isEmpty {
                            digitInput.removeLast()
                        }
                    } label: {
                        Image(systemName: "delete.left")
                            .font(.title2)
                            .padding(8)
                    }
                    .disabled(digitInput.isEmpty)
                    .padding(.trailing)
                }

                // Digit Buttons
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 5), spacing: 8) {
                    ForEach(0..<10) { digit in
                        Button {
                            digitInput.append("\(digit)")
                        } label: {
                            Text("\(digit)")
                                .font(.title2)
                                .frame(maxWidth: .infinity, minHeight: 44)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)

                // Filtered List
                List(filteredQuestions) { question in
                    Button {
                        if let index = viewModel.questions.firstIndex(where: { $0.id == question.id }) {
                            onSelect(index)
                        }
                    } label: {
                        HStack {
                            Text("\(Constants.Labels.question[safe: selectedLanguage]) \(question.id)")
                            if question.id == viewModel.questions[viewModel.currentIndex].id {
                                Spacer()
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle(Constants.Labels.select[safe: selectedLanguage])
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    QuestionListView()
}
