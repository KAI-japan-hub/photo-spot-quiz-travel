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
        "Arashiyama Bamboo Grove",
        "Tofuku-ji Temple",
        "Nanzen-ji Temple",
        "Philosopher’s Path",
        "Kyoto Botanical Gardens",
        "Nishiki Market",
        "Gion Shirakawa Area",
        "Kyoto Station",
        "Kamo River",
        "Kamigamo Shrine",
        "Kyoto Imperial Palace",
        "Heian Shrine & Garden",
        "Kiyomizu-dera Temple",
        "Ryōan-ji Temple",
        "Nijo Castle",
        "Kyoto City Kyocera Museum",
        "Shimogamo Shrine",
        "Randen Arashiyama Station",
        "Fushimi Inari Taisha"
        //マンガミュージアムと建仁寺を削除して、龍安寺を追加
    ]

    var body: some View {
        VStack(spacing: 30) {
            Text("Spin the roulette to choose where to go!")
                .font(.title2)
                .padding()

            Text(currentSpot)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.blue)
                .padding()
                .frame(width: 350, height: 200)
                .background(Color.white)
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 2))

            Button(action: {
                startRoulette()
            }) {
                Text(isSpinning ? "Spinning..." : "Start the roulette!")
                    .foregroundColor(.white)
                    .frame(width: 250, height: 50)
                    .background(isSpinning ? Color.gray : Color.orange)
                    .cornerRadius(12)
            }
            .disabled(isSpinning)

            if let selectedSpot = selectedSpot {
                NavigationLink(destination: SpotDetailView(spotName: selectedSpot, locationViewModel: locationViewModel), isActive: $navigateToDetail) {
                    Button("Proceed to the detail") {
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
        .navigationTitle("Complite")
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
