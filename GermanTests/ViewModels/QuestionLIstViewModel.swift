//
//  QuestionLIstViewModel.swift
//  GermanTests
//
//  Created by Serge Sinkevych on 6/5/25.
//

import Foundation

@Observable
class QuestionViewModel {
    
    var questions: [ExamQuestion] = []
    var currentIndex = 0
    var selectedAnswer: ExamAnswer?
    var showTranslation = false
    
    var selectedLanguage: Language {
        showTranslation ? Language.init(from: UserDefaults.standard.string(forKey: "selectedLanguage")) : Language.de
    }
    
    var currentQuestion: ExamQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    init(mode: TestMode) {
        loadQuestions(for: mode)
    }

    func loadQuestions(for mode: TestMode) {
        guard let url = Bundle.main.url(forResource: "questions", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let result = try? JSONDecoder().decode(QuestionList.self, from: data)
        else {
            print("Failed to load JSON")
            return
        }
        
        let questions = result.questions.filter { !$0.id.isEmpty }
        
        switch mode {
        case .practice:
            self.questions = questions
        case .test:
            self.questions = selectShuffledQuestions(from: questions)
        }
    }
    
    func selectShuffledQuestions(from allQuestions: [ExamQuestion]) -> [ExamQuestion] {
        let groupSize = 10
        let numberOfGroups = allQuestions.count / groupSize
        var selectedQuestions: [ExamQuestion] = []

        // Step 1: Pick 1 random question from each group
        for groupIndex in 0..<numberOfGroups {
            let start = groupIndex * groupSize
            let group = Array(allQuestions[start..<start + groupSize])
            if let randomQuestion = group.randomElement() {
                selectedQuestions.append(randomQuestion)
            }
        }

        // Step 2: Add 2 more random questions from any group to make it 33
        let remainingQuestions = allQuestions.filter { !selectedQuestions.contains($0) }
        selectedQuestions += remainingQuestions.shuffled().prefix(33 - selectedQuestions.count)

        // Step 3: Shuffle the final selection
        return selectedQuestions.shuffled()
    }

    func goNext() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
            selectedAnswer = nil
        }
    }

    func goBack() {
        if currentIndex > 0 {
            currentIndex -= 1
            selectedAnswer = nil
        }
    }
}

struct QuestionList: Codable {
    let questions: [ExamQuestion]
}
