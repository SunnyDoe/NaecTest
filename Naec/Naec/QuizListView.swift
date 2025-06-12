//
//  ContentView.swift
//  Naec
//
//  Created by Sandro Tsitskishvili on 12.06.25.
//

import SwiftUI

struct QuizListView: View {
    @StateObject var vm = QuizViewModel()

    var body: some View {
        NavigationView {
            List(vm.questions) { q in
                NavigationLink(destination:
                    QuizDetailView(viewModel: vm, quiz: q)
                ) {
                    VStack(alignment: .leading) {
                        Text("№\(q.number)").font(.headline)
                        Text(q.question.prefix(80) + "…")
                            .font(.subheadline).foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("კითხვები")
            .toolbar {
                NavigationLink("Score", destination: ScoreSummaryView(viewModel: vm))
            }
        }
        .onAppear { vm.loadQuestions() }
        .sheet(isPresented: $vm.showScore) {
            ScoreSummaryView(viewModel: vm)
        }
    }
}


#Preview {
    QuizListView()
}
