import SwiftUI
import MapKit
import CoreLocation

//位置情報

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    @ObservedObject var locationViewModel = LocationViewModel()
    // 複数の場所のデータ (最新の19スポットとそれぞれの代表地点の緯度・経度)
    private let locations = [
        Location(name: "嵐山の竹林の道", coordinate: CLLocationCoordinate2D(latitude: 35.0167982, longitude: 135.6712782)),
        Location(name: "東福寺", coordinate: CLLocationCoordinate2D(latitude: 34.9763286, longitude: 135.7737616)),
        Location(name: "南禅寺", coordinate: CLLocationCoordinate2D(latitude: 35.012916, longitude: 135.796164)),
        Location(name: "哲学の道", coordinate: CLLocationCoordinate2D(latitude: 35.026603, longitude: 135.795454)),
        Location(name: "京都府立植物園", coordinate: CLLocationCoordinate2D(latitude: 35.044005, longitude: 135.764506)),
        Location(name: "錦市場", coordinate: CLLocationCoordinate2D(latitude: 35.005008, longitude: 135.764591)),
        Location(name: "祇園白川沿い", coordinate: CLLocationCoordinate2D(latitude: 35.004128, longitude: 135.774574)),
        Location(name: "京都駅", coordinate: CLLocationCoordinate2D(latitude: 34.985588, longitude: 135.758749)),
        Location(name: "鴨川", coordinate: CLLocationCoordinate2D(latitude: 35.030147, longitude: 135.771765)), // 出町柳・鴨川デルタの座標
        Location(name: "上賀茂神社", coordinate: CLLocationCoordinate2D(latitude: 35.0604016, longitude: 135.752733)),
        Location(name: "京都御所", coordinate: CLLocationCoordinate2D(latitude: 35.0265665, longitude: 135.7598749)),
        Location(name: "平安神宮と神苑", coordinate: CLLocationCoordinate2D(latitude: 35.01613, longitude: 135.7824269)),
        Location(name: "清水寺", coordinate: CLLocationCoordinate2D(latitude: 34.9948282, longitude: 135.7848819)),
        Location(name: "伏見稲荷大社", coordinate: CLLocationCoordinate2D(latitude: 34.967, longitude: 135.773)),
        Location(name: "京都国際マンガミュージアム", coordinate: CLLocationCoordinate2D(latitude: 35.011689, longitude: 135.760124)),
        Location(name: "二条城", coordinate: CLLocationCoordinate2D(latitude: 35.0141068, longitude: 135.7478229)),
        Location(name: "京都市京セラ美術館", coordinate: CLLocationCoordinate2D(latitude: 35.014605, longitude: 135.781373)),
        Location(name: "下鴨神社", coordinate: CLLocationCoordinate2D(latitude: 35.0389744, longitude: 135.7726864)),
        Location(name: "嵐電嵐山駅", coordinate: CLLocationCoordinate2D(latitude: 35.015362, longitude: 135.6782134)),
        Location(name: "京都産業大学", coordinate: CLLocationCoordinate2D(latitude: 35.0692046, longitude: 135.7556836))
    ]
    
    // 地図の初期状態を管理するための状態変数
    @State private var position: MapCameraPosition = .automatic
    
    var body: some View {
        Map(position: $position) {
            // 各場所にマーカーを追加
            ForEach(locations) { location in
                Annotation(location.name, coordinate: location.coordinate) {
                    NavigationLink(destination: SpotDetailView(spotName: location.name, locationViewModel: locationViewModel)) {
                        VStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                                .font(.title)
                            Text(location.name)
                                .font(.caption)
                                .foregroundColor(.black)
                                .padding(4)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(4)
                        }
                    }
                }
            }
            if let userLocation = locationViewModel.userLocation {
                Marker("現在地", coordinate: userLocation)
                    .tint(.blue)
            }
        }
        .onAppear {
            // 地図が表示されたときに位置を設定（すべてのマーカーが表示される範囲に）
            position = .region(regionForAllLocations())
        }
    }
    
    // すべての場所を含むリージョンを計算
    private func regionForAllLocations() -> MKCoordinateRegion {
        let minLat = locations.map { $0.coordinate.latitude }.min() ?? 35.0
        let maxLat = locations.map { $0.coordinate.latitude }.max() ?? 35.1
        let minLon = locations.map { $0.coordinate.longitude }.min() ?? 135.7
        let maxLon = locations.map { $0.coordinate.longitude }.max() ?? 135.8
        
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        
        // 緯度・経度の差に少し余裕を持たせる
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.1,
            longitudeDelta: (maxLon - minLon) * 1.1
        )
        
        return MKCoordinateRegion(center: center, span: span)
    }
}
