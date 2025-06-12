//
//  QuizViewModel.swift
//  Naec
//
//  Created by Sandro Tsitskishvili on 12.06.25.
//

import Foundation
import PDFKit
import SwiftUI

class QuizViewModel: ObservableObject {
    @Published var questions: [QuizQuestion] = []
    @Published var showScore = false

    private let answersKey = "savedAnswers"

    func loadQuestions() {
        guard let url = Bundle.main.url(forResource: "ზოგადი უნარები I ვარიანტი ქართულად", withExtension: "pdf"),
              let pdf = PDFDocument(url: url) else { return }

        let allowedRange = 3...7 // Pages 4–8 (inclusive)
        let text = allowedRange
            .compactMap { pdf.page(at: $0)?.string }
            .joined(separator: "\n")

        // Keep the existing regex and parsing logic
        let pattern = #"(?m)(\d{1,2})\.\s(.+?)\s+ა\)(.+?)\s+ბ\)(.+?)\s+გ\)(.+?)(?:\s+დ\)(.+?))?(?:\s+ე\)(.+?))?(?=\n\d{1,2}\.|$)"#

        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators])
            let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))

            var result: [QuizQuestion] = []

            for match in matches {
                let ns = text as NSString
                let number = Int(ns.substring(with: match.range(at: 1))) ?? 0
                let question = ns.substring(with: match.range(at: 2)).trimmingCharacters(in: .whitespacesAndNewlines)

                var options: [String] = []
                for i in 3...7 where match.range(at: i).location != NSNotFound {
                    options.append(ns.substring(with: match.range(at: i)).trimmingCharacters(in: .whitespacesAndNewlines))
                }

                result.append(QuizQuestion(number: number, question: question, options: options))
            }

            DispatchQueue.main.async {
                self.questions = result
            }

        } catch {
            print("Regex error:", error)
        }
    }
    func setCorrectAnswers(_ mapping: [Int:Int]) {
        for i in questions.indices {
            questions[i].correctIndex = mapping[questions[i].number]
        }
    }

    func selectAnswer(q: QuizQuestion, index: Int) {
        guard let i = questions.firstIndex(where: { $0.id == q.id }) else { return }
        questions[i].selectedIndex = index
        saveSelections()
        if questions.filter({ $0.selectedIndex == nil }).isEmpty {
            showScore = true
        }
    }

    private func saveSelections() {
        let dict: [Int: Int] = Dictionary(uniqueKeysWithValues: questions.compactMap { q in
            guard let sel = q.selectedIndex else { return nil }
            return (q.number, sel)
        })
        UserDefaults.standard.set(dict, forKey: answersKey)
    }

    private func restoreSelections() {
        guard let dict = UserDefaults.standard.dictionary(forKey: answersKey)
                 as? [Int: Int] else { return }
        setCorrectAnswers([:]) // no changes
        for i in questions.indices {
            questions[i].selectedIndex = dict[questions[i].number]
        }
        if questions.filter({ $0.selectedIndex == nil }).isEmpty {
            showScore = true
        }
    }

    func totalCorrect() -> Int {
        questions.filter { $0.selectedIndex == $0.correctIndex }.count
    }
}
