//
//  ContentView.swift
//  KaiKai
//
//  Created by 山口翔生 on 2025/04/30.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var locationViewModel = LocationViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                // ★ シンプルなグラデーション背景
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.white]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    if let location = locationViewModel.userLocation {
                        Text("Latitude: \(location.latitude)")
                        Text("Longitude: \(location.longitude)")
                    }

                    Text("Thank you for cooperating with my experiment!")
                    Text("実験にご参加いただきありがとうございます！")
                        .multilineTextAlignment(.center)
                        .padding()

                    NavigationLink(destination: NextView()) {
                        Text("Proceed to next：同意済み")
                            .foregroundColor(.black)
                            .frame(width: 240, height: 50)
                            .background(Color.cyan)
                            .cornerRadius(25)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}

struct NextView: View {
    @ObservedObject var locationViewModel = LocationViewModel()

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 20) {
                // ✅ アプリのロゴ（例: AppLogo.png をAssetsに追加済みと仮定）
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 5)

                // ✅ ダークモード対応のテキスト
                Text("・実験内容を確認したい方は手順書を、実験を開始したい人は行き先確認画面へ進んでください。")
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding()

                Text("・If you want to review the experiment instruction, please refer to the procedure manual. If you're ready to begin the experiment, proceed to the destination confirmation screen.")
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)

                // ボタン群（変更なし）
                NavigationLink(destination: Instruction()) {
                    Text("実験手順書: Experiment instruction")
                        .foregroundColor(.black)
                        .frame(width: 280, height: 50)
                        .background(Color.cyan)
                        .cornerRadius(25)
                }
                // 性格診断ボタンを追加
                Link(destination: URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSfk3OoOW0kggM1OXu42zcUN0cTMkZR3adqjlqkA2CwQYbzdwg/viewform?usp=dialog")!) {
                    Text("性格診断")
                        .foregroundColor(.white)
                        .frame(width: 280, height: 50)
                        .background(Color.purple) // 好きな色に変更
                        .cornerRadius(25)
                }
                .padding(.bottom, 20)

                NavigationLink(destination: MapExplanation()) {
                    Text("行き先確認: Destination confirmation")
                        .foregroundColor(.black)
                        .frame(width: 280, height: 50)
                        .background(Color.mint)
                        .cornerRadius(25)
                }

                NavigationLink(destination: RouletteDestinationView(locationViewModel: locationViewModel)) {
                    Text("ランダムで行き先を決定！")
                        .foregroundColor(.white)
                        .frame(width: 280, height: 50)
                        .background(Color.orange)
                        .cornerRadius(25)
                }
            }
            .padding()
        }
    }
}

struct MapExplanation: View {
    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea() // ★ うすいグレー背景

            VStack(spacing: 30) {
                Text("Decide your next destination from the map.")
                Text("マップから次の目的地を決めてください。")
                    .multilineTextAlignment(.center)

                NavigationLink(destination: MapView()) {
                    Text("次へ：Next")
                        .foregroundColor(.black)
                        .frame(width: 200, height: 50)
                        .background(Color.cyan)
                        .cornerRadius(25)
                }
            }
            .padding()
        }
    }
}

#Preview {
    MapExplanation()
}
