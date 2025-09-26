import SwiftUI
import MapKit
import CoreLocation

// MARK: - Model
struct Location: Identifiable, Equatable, Hashable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D

    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.name == rhs.name &&
               lhs.coordinate.latitude == rhs.coordinate.latitude &&
               lhs.coordinate.longitude == rhs.coordinate.longitude
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
    }
}


// MARK: - 日本語→英語の対応辞書
private let jpToEn: [String: String] = [
    "嵐山の竹林の道": "Arashiyama Bamboo Grove Path",
    "東福寺": "Tofuku-ji Temple",
    "南禅寺": "Nanzen-ji Temple",
    "哲学の道": "Philosopher’s Path",
    "京都府立植物園": "Kyoto Botanical Gardens",
    "錦市場": "Nishiki Market",
    "祇園白川沿い": "Gion Shirakawa Riverside",
    "京都駅": "Kyoto Station",
    "鴨川": "Kamo River (Demachiyanagi Delta)",
    "上賀茂神社": "Kamigamo Shrine",
    "京都御所": "Kyoto Imperial Palace",
    "平安神宮と神苑": "Heian Shrine & Gardens",
    "清水寺": "Kiyomizu-dera Temple",
    "伏見稲荷大社": "Fushimi Inari Taisha",
    "京都国際マンガミュージアム": "Kyoto International Manga Museum",
    "二条城": "Nijo Castle",
    "京都市京セラ美術館": "Kyoto City Kyocera Museum of Art",
    "下鴨神社": "Shimogamo Shrine",
    "嵐電嵐山駅": "Randen Arashiyama Station",
]

// MARK: - SwiftUI Wrapper（外からはこの View を使う）
struct MapView: View {
    @StateObject var locationViewModel = LocationViewModel()

    // あなたの元の配列（日本語名のまま）
    private let locations: [Location] = [
        .init(name: "嵐山の竹林の道", coordinate: .init(latitude: 35.0167982, longitude: 135.6712782)),
        .init(name: "東福寺", coordinate: .init(latitude: 34.9763286, longitude: 135.7737616)),
        .init(name: "南禅寺", coordinate: .init(latitude: 35.012916, longitude: 135.796164)),
        .init(name: "哲学の道", coordinate: .init(latitude: 35.026603, longitude: 135.795454)),
        .init(name: "京都府立植物園", coordinate: .init(latitude: 35.044005, longitude: 135.764506)),
        .init(name: "錦市場", coordinate: .init(latitude: 35.005008, longitude: 135.764591)),
        .init(name: "祇園白川沿い", coordinate: .init(latitude: 35.004128, longitude: 135.774574)),
        .init(name: "京都駅", coordinate: .init(latitude: 34.985588, longitude: 135.758749)),
        .init(name: "鴨川", coordinate: .init(latitude: 35.030147, longitude: 135.771765)),
        .init(name: "上賀茂神社", coordinate: .init(latitude: 35.0604016, longitude: 135.752733)),
        .init(name: "京都御所", coordinate: .init(latitude: 35.0265665, longitude: 135.7598749)),
        .init(name: "平安神宮と神苑", coordinate: .init(latitude: 35.01613, longitude: 135.7824269)),
        .init(name: "清水寺", coordinate: .init(latitude: 34.9948282, longitude: 135.7848819)),
        .init(name: "伏見稲荷大社", coordinate: .init(latitude: 34.967, longitude: 135.773)),
        .init(name: "京都国際マンガミュージアム", coordinate: .init(latitude: 35.011689, longitude: 135.760124)),
        .init(name: "二条城", coordinate: .init(latitude: 35.0141068, longitude: 135.7478229)),
        .init(name: "京都市京セラ美術館", coordinate: .init(latitude: 35.014605, longitude: 135.781373)),
        .init(name: "下鴨神社", coordinate: .init(latitude: 35.0389744, longitude: 135.7726864)),
        .init(name: "嵐電嵐山駅", coordinate: .init(latitude: 35.015362, longitude: 135.6782134)),
        .init(name: "京都産業大学", coordinate: .init(latitude: 35.0692046, longitude: 135.7556836))
    ]

    // ピン選択→詳細画面に飛ばす場合の選択状態
    @State private var selected: Location?

    var body: some View {
        NavigationStack {
            MapUIKitView(
                locations: locations,
                selected: $selected
            )
            .navigationDestination(item: $selected) { loc in
                // 既存の SpotDetailView がある前提
                SpotDetailView(spotName: loc.name, locationViewModel: locationViewModel)
            }
            .ignoresSafeArea()
        }
    }
}

// MARK: - UIViewRepresentable（MKMapView をラップ）
struct MapUIKitView: UIViewRepresentable {
    let locations: [Location]
    @Binding var selected: Location?

    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.delegate = context.coordinator
        map.showsUserLocation = true                   // 青い現在地ドット
        map.pointOfInterestFilter = .includingAll
        map.isRotateEnabled = false

        // ピン追加
        addAnnotations(to: map)

        // すべてが入るように初期リージョン設定
        if let region = regionForAll(locations: locations) {
            map.setRegion(region, animated: false)
        }
        return map
    }

    func updateUIView(_ map: MKMapView, context: Context) {
        // 必要なら再描画（今回は静的なので何もしない）
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: - Helpers
    private func addAnnotations(to map: MKMapView) {
        let pins: [MKPointAnnotation] = locations.map { loc in
            let pin = MKPointAnnotation()
            pin.coordinate = loc.coordinate
            pin.title = loc.name                                   // 日本語
            pin.subtitle = jpToEn[loc.name] ?? loc.name            // 英語（なければ日本語再掲）
            return pin
        }
        map.addAnnotations(pins)
    }

    private func regionForAll(locations: [Location]) -> MKCoordinateRegion? {
        guard !locations.isEmpty else { return nil }
        let lats = locations.map { $0.coordinate.latitude }
        let lons = locations.map { $0.coordinate.longitude }
        let minLat = lats.min()!, maxLat = lats.max()!
        let minLon = lons.min()!, maxLon = lons.max()!
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2.0,
                                            longitude: (minLon + maxLon) / 2.0)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.2,
                                    longitudeDelta: (maxLon - minLon) * 1.2)
        return MKCoordinateRegion(center: center, span: span)
    }

    // MARK: - Coordinator
    final class Coordinator: NSObject, MKMapViewDelegate {
        private let parent: MapUIKitView
        init(_ parent: MapUIKitView) { self.parent = parent }

        // カスタム見た目＆吹き出し表示
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // ユーザー位置はデフォルト表示
            if annotation is MKUserLocation { return nil }

            let id = "jp-en-pin"
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView
                ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: id)

            view.annotation = annotation
            view.canShowCallout = true
            view.markerTintColor = .systemRed
            view.glyphImage = UIImage(systemName: "mappin")
            view.titleVisibility = .visible
            view.subtitleVisibility = .visible

            // 右側に “詳細へ” のボタン（任意）
            let button = UIButton(type: .detailDisclosure)
            view.rightCalloutAccessoryView = button

            return view
        }

        // 吹き出しの ⓘ ボタンタップ → Selection を更新（ナビゲーション発火）
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                     calloutAccessoryControlTapped control: UIControl) {
            guard let title = view.annotation?.title ?? nil,
                  let loc = parent.locations.first(where: { $0.name == title }) else { return }
            parent.selected = loc
        }
    }
}



/**日本語表記のみ**/
/*import SwiftUI
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
*/
