//
//  Model.swift
//  Naec
//
//  Created by Sandro Tsitskishvili on 12.06.25.
//

import Foundation

struct QuizQuestion: Identifiable {
    let id = UUID()
    let number: Int
    let question: String
    let options: [String]
    var correctIndex: Int?
    var selectedIndex: Int?
}
