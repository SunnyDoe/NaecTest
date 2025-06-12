//
//  QuizDetailView.swift
//  Naec
//
//  Created by Sandro Tsitskishvili on 12.06.25.
//

import SwiftUI

struct QuizDetailView: View {
    @ObservedObject var viewModel: QuizViewModel
    let quiz: QuizQuestion

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("კითხვა №\(quiz.number)")
                    .font(.headline)

                Text(quiz.question)
                    .font(.title3)
                    .fixedSize(horizontal: false, vertical: true) // ✅ wrap multiline

                ForEach(quiz.options.indices, id: \.self) { i in
                    Button {
                        viewModel.selectAnswer(q: quiz, index: i)
                    } label: {
                        HStack {
                            Text("\(["ა","ბ","გ","დ","ე"][i])  \(quiz.options[i])")
                                .multilineTextAlignment(.leading)
                            Spacer()
                            if quiz.selectedIndex == i {
                                Image(systemName: i == quiz.correctIndex ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(i == quiz.correctIndex ? .green : .red)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .disabled(quiz.selectedIndex != nil)
                }

                if let selected = quiz.selectedIndex,
                   let correct = quiz.correctIndex {
                    Text(selected == correct ? "სწორია ✅" : "არასწორია ❌")
                        .foregroundColor(selected == correct ? .green : .red)
                        .font(.title3)
                        .bold()
                        .padding(.top, 12)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("კითხვა")
    }
}
