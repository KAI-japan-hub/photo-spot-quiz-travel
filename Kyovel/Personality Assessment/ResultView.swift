//
//  ResultView.swift
//  KaiKai
//
//  Created by 山口翔生 on 2025/07/08.
//

import SwiftUI

struct ResultView: View {
    let csScore: Double
    let esScore: Double
    let gsScore: Double
    let asScore: Double

    var body: some View {
        VStack(spacing: 20) {
            Text("あなたの性格タイプ診断結果")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)
                .multilineTextAlignment(.center)

            VStack(alignment: .leading, spacing: 10) {
                Text(String(format: "協調性スコア(CS): %.2f", csScore))
                Text(String(format: "探究心スコア(ES): %.2f", esScore))
                Text(String(format: "目的志向スコア(GS): %.2f", gsScore))
                Text(String(format: "主体性スコア(AS): %.2f", asScore))
            }
            .font(.title2)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 3)

            Divider()

            Text("最も傾向が強いのは...")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.top, 20)

            // 最も高いスコアを持つカテゴリを特定
            let scores = [
                ("CS", csScore),
                ("ES", esScore),
                ("GS", gsScore),
                ("AS", asScore)
            ]

            let maxScore = scores.map { $0.1 }.max() ?? 0.0

            if maxScore == 0.0 && scores.allSatisfy({ $0.1 == 0.0 }) {
                Text("スコアが計算できませんでした。")
                    .font(.title2)
                    .foregroundColor(.gray)
            } else {
                ForEach(scores.filter { $0.1 == maxScore }, id: \.0) { categoryName, score in
                    VStack {
                        Text(categoryName)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.orange)
                        Text(String(format: "(平均スコア: %.2f)", score))
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 5)
                }
            }
            Text("※スクリーンショットを撮って記録してください")
            Text("※もしも、複数個最も傾向が強いものがあったら、自分で最も適切だと思うものを一つ選んでください")

            Spacer()
        }
        .padding()
        .navigationTitle("診断結果")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// プレビュー用
struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        // ダミーデータでプレビュー
        ResultView(csScore: 4.5, esScore: 3.8, gsScore: 4.5, asScore: 2.1)
    }
}
