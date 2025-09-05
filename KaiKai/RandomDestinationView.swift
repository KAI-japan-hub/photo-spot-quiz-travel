import SwiftUI

struct RouletteDestinationView: View {
    @ObservedObject var locationViewModel: LocationViewModel
    @State private var currentSpot: String = "？"
    @State private var isSpinning = false
    @State private var selectedSpot: String?
    @State private var timer: Timer?
    @State private var spinCount = 0
    @State private var navigateToDetail = false

    // ルーレットの候補となるスポットリストを最新の19スポットに更新
    private let allSpots: [String] = [
        "嵐山の竹林の道",
        "東福寺", // 変更: 東福寺（通天橋） -> 東福寺
        "南禅寺", // 変更: 南禅寺 水路閣 -> 南禅寺
        "哲学の道",
        "京都府立植物園",
        "錦市場",
        "祇園白川沿い",
        "京都駅", // 変更: 京都駅大階段と空中径路 -> 京都駅
        "鴨川", // 変更: 出町柳・鴨川デルタ -> 鴨川
        "上賀茂神社",
        "京都御所",
        "平安神宮と神苑",
        "清水寺", // 変更: 清水寺（舞台付近） -> 清水寺
        "龍安寺", // 変更: 建仁寺（襖絵・枯山水） -> 建仁寺
        "二条城", // 変更: 二条城（二の丸御殿） -> 二条城
        "京都市京セラ美術館",
        "下鴨神社", // 変更: 下鴨神社 糺の森 -> 下鴨神社
        "嵐電嵐山駅",
        "伏見稲荷大社",
        //マンガミュージアムと建仁寺を削除して、龍安寺を追加
    ]

    var body: some View {
        VStack(spacing: 30) {
            Text("ルーレットで行き先を決めよう！")
                .font(.title2)
                .padding()

            Text(currentSpot)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.blue)
                .padding()
                .frame(width: 250, height: 100)
                .background(Color.white)
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 2))

            Button(action: {
                startRoulette()
            }) {
                Text(isSpinning ? "スピン中..." : "ルーレットスタート！")
                    .foregroundColor(.white)
                    .frame(width: 250, height: 60)
                    .background(isSpinning ? Color.gray : Color.orange)
                    .cornerRadius(12)
            }
            .disabled(isSpinning)

            if let selectedSpot = selectedSpot {
                NavigationLink(destination: SpotDetailView(spotName: selectedSpot, locationViewModel: locationViewModel), isActive: $navigateToDetail) {
                    Button("行き先へ進む") {
                        navigateToDetail = true
                    }
                    .padding()
                    .frame(width: 200, height: 50)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .navigationTitle("ルーレット行き先決定")
    }

    private func startRoulette() {
        isSpinning = true
        spinCount = 0
        selectedSpot = nil

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { t in
            spinCount += 1
            currentSpot = allSpots.randomElement()!

            // 徐々にスローにして終了する
            if spinCount > 25 {
                t.invalidate()
                selectedSpot = currentSpot
                isSpinning = false
            }
        }
    }
}
