//
//  EnqueteView.swift
//  KaiKai
//
//  Created by 山口翔生 on 2025/07/08.
//

import SwiftUI

struct Question: Identifiable {
    let id = UUID()
    let text: String
    let category: String // "協調性", "探究心", "目的志向", "主体性"
    let categoryKey: String // "CS", "ES", "GS", "AS"
}

struct EnqueteView: View {
    // 質問リスト
    @State private var questions: [Question] = [
        // ① 協調性・共同志向（Collaborative Orientation）
        Question(text: "他の人と一緒に何かを計画したり、行動したりするのが好きだ。", category: "協調性", categoryKey: "CS"),
        Question(text: "グループで目標を達成することに、個人的なやりがいを強く感じる。", category: "協調性", categoryKey: "CS"),
        Question(text: "友人との旅行では、みんなで話し合い、意見を合わせて行動するのが楽しい。", category: "協調性", categoryKey: "CS"),
        Question(text: "グループ内で誰かが困っていたら、積極的に手助けしたいと思う。", category: "協調性", categoryKey: "CS"),
        Question(text: "自分の意見を主張するよりも、グループ全体の調和を優先することが多い。", category: "協調性", categoryKey: "CS"),
        Question(text: "チームで活動する際、役割分担がある方が効率が良いと感じる。", category: "協調性", categoryKey: "CS"),

        // ② ゲーム感覚・好奇心（Exploratory & Playful Attitude）
        Question(text: "観光地を訪れる際、ただ見るだけでなく、ゲームやミッションがあるとより楽しめる。", category: "探究心", categoryKey: "ES"),
        Question(text: "新しい場所を探したり、隠れたスポットを見つけたりする過程にワクワクする。", category: "探究心", categoryKey: "ES"),
        Question(text: "スマートフォンアプリを使った、謎解きやスタンプラリーのような体験に魅力を感じる。", category: "探究心", categoryKey: "ES"),
        Question(text: "同じ場所でも、以前とは違う見方を試したり、新しい楽しみ方を探したりしたくなる。", category: "探究心", categoryKey: "ES"),
        Question(text: "ちょっとした情報やヒントから、まだ知らない場所やお店を発見するのが好きだ。", category: "探究心", categoryKey: "ES"),
        Question(text: "予期せぬ出来事やハプニングも、旅の面白い要素だとポジティブに捉えられる。", category: "探究心", categoryKey: "ES"),

        // ③ 目的志向・計画性（Goal Orientation & Planning）
        Question(text: "旅行に行く前には、訪れる場所や移動手段、時間配分などを詳細に計画しておきたい。", category: "目的志向", categoryKey: "GS"),
        Question(text: "旅の目的を明確にし、「なぜそこに行くのか」を自分の中で納得させてから行動したい。", category: "目的志向", categoryKey: "GS"),
        Question(text: "決められた時間内で、できるだけ多くの観光スポットを効率よく巡りたい。", category: "目的志向", categoryKey: "GS"),
        Question(text: "計画通りに物事が進まないと、少し不安になったり、イライラしたりしやすい。", category: "目的志向", categoryKey: "GS"),
        Question(text: "事前に情報収集をしっかり行い、リスクや問題点をできるだけ排除しておきたい。", category: "目的志向", categoryKey: "GS"),
        Question(text: "旅行中に、達成すべき具体的な目標（例：〇〇を必ず見る、〇〇を食べる）を設定することがある。", category: "目的志向", categoryKey: "GS"),

        // ④ 主体性・自由探索型（Autonomous & Intuitive Explorer）
        Question(text: "旅行中は、自分の気分や直感に従って、その場の状況で行動を決めるのが好きだ。", category: "主体性", categoryKey: "AS"),
        Question(text: "誰かに指示されるよりも、自分で考えてルートを選び、行動する方が楽しい。", category: "主体性", categoryKey: "AS"),
        Question(text: "決まった計画に縛られることなく、自由に気の向くままに歩き回ることを楽しめる。", category: "主体性", categoryKey: "AS"),
        Question(text: "事前にあまり情報を調べず、現地での発見や驚きを楽しみたい。", category: "主体性", categoryKey: "AS"),
        Question(text: "道に迷ったり、予定外の場所に着いたりしても、それも旅の醍醐味だと感じることが多い。", category: "主体性", categoryKey: "AS"),
        Question(text: "グループ行動よりも、一人または少人数で行動する方が、自分のペースで動けて快適だ。", category: "主体性", categoryKey: "AS")
    ]

    // 各質問の回答を保持する辞書
    @State private var answers: [UUID: Int] = [:]

    // 結果画面へのナビゲーションを制御
    @State private var navigateToResult = false
    // 計算されたスコアを保持
    @State private var csScore: Double = 0
    @State private var esScore: Double = 0
    @State private var gsScore: Double = 0
    @State private var asScore: Double = 0

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("性格診断アンケート")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)

                    Text("以下の質問に対し、あなたに最も当てはまるものを1（全くそう思わない）〜5とてもそう思う）で選んでください。")
                        .font(.body)
                        .padding(.bottom, 20)

                    ForEach(questions.indices, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("\(index + 1). \(questions[index].text)")
                                .font(.headline)
                            Picker("質問 \(index + 1)", selection: Binding(
                                get: { self.answers[questions[index].id] ?? 0 }, // デフォルト値は0
                                set: { self.answers[questions[index].id] = $0 }
                            )) {
                                ForEach(1...5, id: \.self) { num in
                                    Text("\(num)").tag(num)
                                }
                            }
                            .pickerStyle(.segmented) // セグメントコントロールで表示
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    }

                    Button(action: calculateScoresAndNavigate) {
                        Text("結果を見る")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(15)
                    }
                    .padding(.top, 30)
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle("") // カスタムタイトルを使用するため非表示
            .navigationBarHidden(true) // カスタムタイトルを使用するため非表示
            .background(
                NavigationLink(
                    destination: ResultView(
                        csScore: csScore,
                        esScore: esScore,
                        gsScore: gsScore,
                        asScore: asScore
                    ),
                    isActive: $navigateToResult,
                    label: { EmptyView() }
                )
                .hidden()
            )
        }
    }

    private func calculateScoresAndNavigate() {
        // 全ての質問に回答されているかチェック（オプション）
        // if answers.count != questions.count {
        //     // アラート表示など
        //     return
        // }

        var csSum: Double = 0
        var esSum: Double = 0
        var gsSum: Double = 0
        var asSum: Double = 0

        var csCount: Int = 0
        var esCount: Int = 0
        var gsCount: Int = 0
        var asCount: Int = 0

        for question in questions {
            if let answer = answers[question.id] {
                switch question.categoryKey {
                case "CS":
                    csSum += Double(answer)
                    csCount += 1
                case "ES":
                    esSum += Double(answer)
                    esCount += 1
                case "GS":
                    gsSum += Double(answer)
                    gsCount += 1
                case "AS":
                    asSum += Double(answer)
                    asCount += 1
                default:
                    break
                }
            }
        }

        csScore = csCount > 0 ? csSum / Double(csCount) : 0
        esScore = esCount > 0 ? esSum / Double(esCount) : 0
        gsScore = gsCount > 0 ? gsSum / Double(gsCount) : 0
        asScore = asCount > 0 ? asSum / Double(asCount) : 0

        navigateToResult = true
    }
}

// プレビュー用
struct EnqueteView_Previews: PreviewProvider {
    static var previews: some View {
        EnqueteView()
    }
}
