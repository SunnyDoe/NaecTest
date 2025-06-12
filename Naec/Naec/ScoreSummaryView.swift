//
//  ScoreSummaryView.swift
//  Naec
//
//  Created by Sandro Tsitskishvili on 12.06.25.
//

import SwiftUI

struct ScoreSummaryView: View {
    @ObservedObject var viewModel: QuizViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text("თქვენი შედეგი:").font(.title)
            Text("\(viewModel.totalCorrect()) / \(viewModel.questions.count)")
                .font(.largeTitle).bold()
            Button("Close") {
                viewModel.showScore = false
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
