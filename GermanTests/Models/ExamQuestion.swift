//
//  ExamQuestion.swift
//  GermanTests
//
//  Created by Serge Sinkevych on 6/5/25.
//

import Foundation

struct ExamQuestion: Identifiable, Codable, Equatable {
    let id: String
    let original: String
    let translated: String
    let image: String?
    let answers: [ExamAnswer]
    let correctAnswerId: String
}

struct ExamAnswer: Identifiable, Codable, Equatable {
    let id: String
    let original: String
    let translated: String
}
