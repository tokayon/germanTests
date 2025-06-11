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

    var currentQuestion: ExamQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    init(mode: ExamMode) {
        loadQuestions(for: mode)
    }

    func loadQuestions(for mode: ExamMode) {
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
        case .exam(let questionsCount):
            self.questions = Array(questions.shuffled().prefix(questionsCount))
        }
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
