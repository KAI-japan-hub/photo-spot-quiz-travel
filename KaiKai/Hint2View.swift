//
//  Hint2View.swift
//  KaiKai
//
//  Created by 山口翔生 on 2025/05/28.
//

import SwiftUI
import MapKit

struct Hint2View: View {
    let spotName: String
    
    // 各スポットのヒント情報を格納する辞書
    private let spotHints: [String: [String]] = [
        // 映えスポット・自然美（ポジティブ感情が出やすい）
        "嵐山の竹林の道": [
            "T字路が近くにあります"
        ],
        "東福寺": [ // 変更: 東福寺（通天橋） -> 東福寺
            "上に橋が見えて綺麗"
        ],
        "南禅寺": [], // 変更: 南禅寺 水路閣 -> 南禅寺
        "哲学の道": [],
        "京都府立植物園": [],

        // 街歩き・体験型（楽しい・活気・好奇心）
        "錦市場": [
            "交差点付近です"
        ],
        "祇園白川沿い": [],
        "京都駅": ["少し登る"], 
        "鴨川": [], // 変更: 出町柳・鴨川デルタ -> 鴨川

        // 文化・歴史（静けさ・尊厳・知的好奇心）
        "上賀茂神社": [
            "小さい川のほとりにあるよ"
        ],
        "京都御所": [
            "南北だと少し丸太町通より"
        ],
        "平安神宮と神苑": [],
        "清水寺": [], // 変更: 清水寺（舞台付近） -> 清水寺
        "建仁寺": [], // 変更: 建仁寺（襖絵・枯山水） -> 建仁寺

        // 芸術・体験・個性派（感情の幅が出やすい）
        "京都国際マンガミュージアム": [],
        "二条城": [], // 変更: 二条城（二の丸御殿） -> 二条城
        "京都市京セラ美術館": [],
        "下鴨神社": [], // 変更: 下鴨神社 糺の森 -> 下鴨神社
        "嵐電嵐山駅": [],
        "京都産業大学": ["大学"],
        "伏見稲荷大社": ["奥社奉拝社を過ぎる"]
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("\(spotName)のヒント")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                // ヒントリストの表示
                if let hints = spotHints[spotName] {
                    // ヒントが空でない場合にのみ表示
                    if hints.isEmpty {
                        Text("このスポットのヒントはまだ準備中です。")
                            .padding()
                            .background(Color.yellow.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    } else {
                        ForEach(Array(hints.enumerated()), id: \.offset) { index, hint in
                            VStack(alignment: .leading, spacing: 8) {
                                Text("ヒント2")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                    .padding(.horizontal)
                                
                                Text(hint)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                            }
                        }
                    }
                } else {
                    Text("このスポットのヒントはまだ準備中です。") // スポット名が辞書にない場合
                        .padding()
                        .background(Color.yellow.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding(.vertical)
        }
        .navigationTitle("ヒント2")
        .navigationBarTitleDisplayMode(.inline)
    }
}
