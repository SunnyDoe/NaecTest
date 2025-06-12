//
//  ContentView.swift
//  Naec
//
//  Created by Sandro Tsitskishvili on 12.06.25.
//

import SwiftUI

struct QuizListView: View {
    @StateObject var viewModel = QuizViewModel()

    private func category(for question: QuizQuestion) -> String {
        switch question.number {
        case 1...5, 20...21:
            return "ლოგიკა"
        case 6...9:
            return "წინადადების შევსება"
        case 16...19:
            return "ანალოგია"
        default:
            return "სხვა"
        }
    }

    private var groupedQuestions: [String: [QuizQuestion]] {
        Dictionary(grouping: viewModel.questions, by: category(for:))
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Ვიწერთ კითხვებს...")
                } else {
                    List {
                        ForEach(groupedQuestions.keys.sorted(), id: \.self) { category in
                            Section(header: Text(category).font(.headline)) {
                                ForEach(groupedQuestions[category] ?? []) { question in
                                    NavigationLink(destination: QuizDetailView(question: question)) {
                                        Text("კითხვა \(question.number)")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("ეროვნული 2020")
            .onAppear {
                viewModel.fetchQuestions()
            }
        }
    }
}

#Preview {
    QuizListView()
}

