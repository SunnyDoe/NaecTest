//
//  Model.swift
//  Naec
//
//  Created by Sandro Tsitskishvili on 12.06.25.
//

struct QuizQuestion: Codable, Identifiable {
    var id: Int { number }
    let number: Int
    let question: String
    let options: [String]
    let correctIndex: Int?
}

