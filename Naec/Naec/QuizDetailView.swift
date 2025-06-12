//
//  QuizDetailView.swift
//  Naec
//
//  Created by Sandro Tsitskishvili on 12.06.25.
//

import SwiftUI

struct QuizDetailView: View {
    let question: QuizQuestion
    @State private var selectedIndex: Int?
    @State private var showCorrect = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(question.question)
                    .font(.title3)
                    .fixedSize(horizontal: false, vertical: true) 
                    .padding(.bottom)

                ForEach(question.options.indices, id: \.self) { index in
                    Button(action: {
                        selectedIndex = index
                        showCorrect = true
                    }) {
                        HStack(alignment: .top) {
                            Text(question.options[index])
                                .foregroundColor(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                            if selectedIndex == index {
                                Image(systemName: "circle.inset.filled")
                                    .foregroundColor(.blue)
                            }
                            if showCorrect, let correct = question.correctIndex, index == correct {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .padding()
                        .background(backgroundColor(for: index))
                        .cornerRadius(10)
                    }
                    .disabled(showCorrect)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("კითხვა \(question.number)")
    }

    private func backgroundColor(for index: Int) -> Color {
        guard showCorrect, let correct = question.correctIndex else {
            return Color.gray.opacity(0.1)
        }

        if index == correct {
            return Color.green.opacity(0.3)
        } else if selectedIndex == index {
            return Color.red.opacity(0.3)
        } else {
            return Color.gray.opacity(0.1)
        }
    }
}

