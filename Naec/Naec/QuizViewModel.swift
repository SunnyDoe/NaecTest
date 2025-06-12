//
//  QuizViewModel.swift
//  Naec
//
//  Created by Sandro Tsitskishvili on 12.06.25.
//

import Foundation

class QuizViewModel: ObservableObject {
    @Published var questions: [QuizQuestion] = []
    @Published var isLoading = false
    
    let urlString = "https://raw.githubusercontent.com/SunnyDoe/NaecTest/refs/heads/main/quiz_questions.json"
    
    func fetchQuestions() {
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL")
            return
        }
        
        isLoading = true
        print("🌐 Fetching from:", url)
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            if let error = error {
                print("❌ Network error:", error)
                return
            }
            
            guard let data = data else {
                print("❌ No data received")
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode([QuizQuestion].self, from: data)
                DispatchQueue.main.async {
                    self.questions = decoded
                    print("✅ Questions loaded:", decoded.count)
                }
            } catch {
                print("❌ Decoding error:", error)
            }
        }.resume()
    }
}
