import SwiftUI
import CoreLocation
import simd
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Vision
import CoreML
import VideoToolbox

struct PhotoVerificationView: View {
    let spotName: String
    let spotId: String
    let spotCorrectLabels: [String: String] = [
        "京都産業大学": "京都産業大学(室内)",
        "清水寺": "清水寺",
        "東福寺": "東福寺",
        "錦市場": "錦市場",
        "上賀茂神社": "上賀茂神社",
        "南禅寺": "南禅寺",
        "哲学の道": "哲学の道",
        "京都市京セラ美術館": "京都市京セラ美術館",
        "伏見稲荷大社": "伏見稲荷大社",
        "京都駅": "京都駅",
        // 必要に応じて追加
    ]

    @ObservedObject var locationViewModel: LocationViewModel

    @State private var capturedImage: UIImage?
    @State private var currentLocation: CLLocation?
    @State private var distanceToSpot: Double?
    @State private var locationStatus: String = "位置情報を取得中..."
    @State private var similarityScore: Double?
    @State private var predictionResult: String?
    @State private var confidenceScore: Double?

    private let locationManager = CLLocationManager()

    private let modelFileNames: [String: String] = [
        "清水寺": "KiyomizuClassifier",
        "東福寺": "TofukujiClassifier",
        "嵐山の竹林": "ChikurinClassifier",
        "京都御所": "KyotogoshoClassifier",
        "東本願寺": "HigashihonganjiClassifier",
        "京都産業大学": "KyousanClassifier",
        "錦市場": "nishikiichibaClassifier",
        "上賀茂神社": "KamigamoClassifier",
        "南禅寺": "NanzenjiClassifier",
        "哲学の道": "TetsugakuClassifier",
        "京都市京セラ美術館": "KyoseraClassifier",
        "伏見稲荷大社": "HushimiClassifier",
        "京都駅": "KyotostationClassifier",
    ]

    private let spotImages: [String: String] = [
        "清水寺": "kiyomizu",
        "嵐山の竹林": "chikurin",
        "東本願寺": "higashihonganji",
        "東福寺": "tohukuji",
        "京都御所": "kyotogosho",
        "京都産業大学": "kyousan",
        "錦市場": "nishikiichiba",
        "上賀茂神社": "kamigamo",
        "南禅寺": "nanzenji",
        "哲学の道": "tetsugaku",
        "京都市京セラ美術館": "kyosera",
        "伏見稲荷大社": "hushimi",
        "京都駅": "kyotostation",
    ]

    private let spotLocations: [String: CLLocationCoordinate2D] = [
        "清水寺": CLLocationCoordinate2D(latitude: 34.9948, longitude: 135.7850),
        "東福寺": CLLocationCoordinate2D(latitude: 34.9774963, longitude: 135.7732795),
        "嵐山の竹林": CLLocationCoordinate2D(latitude: 35.0176438, longitude: 135.6740559),
        "京都御所": CLLocationCoordinate2D(latitude: 35.0219461, longitude: 135.7632605),
        "東本願寺": CLLocationCoordinate2D(latitude: 34.9932465, longitude: 135.7577311),
        "京都産業大学": CLLocationCoordinate2D(latitude: 35.069188, longitude: 135.755591),
        "錦市場": CLLocationCoordinate2D(latitude: 35.0050653, longitude: 135.7656403),
        "上賀茂神社":CLLocationCoordinate2D(latitude: 35.0596640, longitude: 135.7530852),
        "南禅寺":CLLocationCoordinate2D(latitude: 35.0111936, longitude: 135.7940516),
        "哲学の道":CLLocationCoordinate2D(latitude: 35.0187537, longitude: 135.7945243),
        "京都市京セラ美術館":CLLocationCoordinate2D(latitude: 35.013413, longitude: 135.7835856),
        "伏見稲荷大社":CLLocationCoordinate2D(latitude: 34.9668720, longitude: 135.7753653),
        "京都駅":CLLocationCoordinate2D(latitude: 34.985847, longitude: 135.75988),
    ]/*完成したら、SpotAnswerに貼り付ける**/

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("写真判定(横写真で撮ってください)")
                    .font(.largeTitle)
                    .bold()

                if let referenceImage = UIImage(named: spotImages[spotName] ?? "") {
                    VStack {
                        Text("参照画像")
                        Image(uiImage: referenceImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(12)
                    }
                } else {
                    Text("参照画像が見つかりません")
                }

                if let captured = capturedImage {
                    VStack {
                        Text("撮影した画像")
                        Image(uiImage: captured)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(12)
                    }
                } else {
                    Text("まだ写真が撮影されていません")
                    NavigationLink("カメラを起動する") {
                        CameraWrapperView(spotName: spotName, capturedImage: $capturedImage)
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }

                Text(locationStatus)
                if let distance = distanceToSpot {
                    Text("撮影地点とスポットの距離: \(Int(distance)) m")
                        .foregroundColor(distance < 10 ? .green : .red)
                    Text(distance < 10 ? "同じ場所と判定されました！" : "場所が離れています")
                        .font(.headline)
                }

               /* if let similarity = similarityScore {
                    Text("画像の類似度: \(Int(similarity * 100))%")
                        .foregroundColor(similarity > 0.5 ? .green : .red)
                    Text(similarity > 0.5 ? "画像は類似しています！" : "異なる画像の可能性があります")
                        .font(.headline)
                }*/

                if capturedImage != nil {
                    Button("現在地を確認して判定する") {
                        checkLocation()
                    }
                    .padding()
                    .background(Color.cyan)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }

                /*if let ref = UIImage(named: spotImages[spotName] ?? ""), let captured = capturedImage {
                    Button("画像の類似度を判定する") {
                        computeImageSimilarity(ref, captured) { score in
                            DispatchQueue.main.async {
                                self.similarityScore = score
                            }
                        }
                    }
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }*/

                if let captured = capturedImage {
                    Button("\(spotName)か判定") {
                        if let model = loadModel(for: spotName) {
                            if let (result, score) = classifyImage(captured, with: model) {
                                self.predictionResult = result
                                self.confidenceScore = score
                            }
                        }
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    if let result = predictionResult, let score = confidenceScore {
                        Text("モデルの判定結果: \(result) (\(Int(score * 100))%)")
                        
                        if let correctLabel = spotCorrectLabels[spotName],
                           result == correctLabel && score >= 0.9 {
                            Text("正しくスポットが認識されました！")
                                .foregroundColor(.green)
                                .bold()
                        } else {
                            Text("スポットが正しく認識されませんでした")
                                .foregroundColor(.red)
                                .bold()
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            setupLocation()
        }
    }

    func setupLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = LocationDelegate { location in
            self.currentLocation = location
            self.locationStatus = "現在地を取得済み"
        }
        locationManager.startUpdatingLocation()
    }

    func checkLocation() {
        guard let currentCoord = locationViewModel.userLocation,
              let spotCoord = spotLocations[spotName] else {
            self.locationStatus = "位置情報が取得できません"
            return
        }
        let currentLocation = CLLocation(latitude: currentCoord.latitude, longitude: currentCoord.longitude)
        let spotLocation = CLLocation(latitude: spotCoord.latitude, longitude: spotCoord.longitude)
        let distance = currentLocation.distance(from: spotLocation)
        self.distanceToSpot = distance
    }

    func computeImageSimilarity(_ image1: UIImage, _ image2: UIImage, completion: @escaping (Double?) -> Void) {
        guard let ci1 = CIImage(image: image1), let ci2 = CIImage(image: image2) else {
            completion(nil)
            return
        }
        let handler1 = VNImageRequestHandler(ciImage: ci1, options: [:])
        let handler2 = VNImageRequestHandler(ciImage: ci2, options: [:])
        let request = VNGenerateImageFeaturePrintRequest()
        var feature1: VNFeaturePrintObservation?
        var feature2: VNFeaturePrintObservation?
        do {
            try handler1.perform([request])
            feature1 = request.results?.first as? VNFeaturePrintObservation
            try handler2.perform([request])
            feature2 = request.results?.first as? VNFeaturePrintObservation
        } catch {
            print("Error: \(error)")
            completion(nil)
            return
        }
        guard let f1 = feature1, let f2 = feature2 else {
            completion(nil)
            return
        }
        var distance = Float(0)
        try? f1.computeDistance(&distance, to: f2)
        let similarity = max(0.0, 1.0 - Double(distance))
        completion(similarity)
    }

    func loadModel(for spot: String) -> MLModel? {
        guard let fileName = modelFileNames[spot],
              let url = Bundle.main.url(forResource: fileName, withExtension: "mlmodelc") else {
            print("モデルファイルが見つかりません: \(spot)")
            return nil
        }
        do {
            return try MLModel(contentsOf: url)
        } catch {
            print("モデルの読み込みに失敗しました: \(error)")
            return nil
        }
    }

    func classifyImage(_ image: UIImage, with model: MLModel) -> (String, Double)? {
        guard let buffer = image.pixelBuffer(width: 299, height: 299) else { return nil }
        do {
            let input = try MLDictionaryFeatureProvider(dictionary: ["image": MLFeatureValue(pixelBuffer: buffer)])
            let output = try model.prediction(from: input)
            let label = output.featureValue(for: "target")?.stringValue ?? ""
            let probDict = output.featureValue(for: "targetProbability")?.dictionaryValue as? [String: Double] ?? [:]
            let prob = probDict[label] ?? 0.0
            return (label, prob)
        } catch {
            print("予測失敗: \(error)")
            return nil
        }
    }
}

class LocationDelegate: NSObject, CLLocationManagerDelegate {
    var onUpdate: (CLLocation) -> Void
    init(onUpdate: @escaping (CLLocation) -> Void) {
        self.onUpdate = onUpdate
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            onUpdate(location)
            manager.stopUpdatingLocation()
        }
    }
}

extension UIImage {
    func pixelBuffer(width: Int, height: Int) -> CVPixelBuffer? {
        var pixelBuffer: CVPixelBuffer?
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey: true
        ] as CFDictionary
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height,
                                         kCVPixelFormatType_32BGRA, attrs, &pixelBuffer)
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            print("CVPixelBufferCreate failed: \(status)")
            return nil
        }
        CVPixelBufferLockBaseAddress(buffer, [])
        guard let context = CGContext(data: CVPixelBufferGetBaseAddress(buffer),
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        else {
            print("CGContext creation failed")
            CVPixelBufferUnlockBaseAddress(buffer, [])
            return nil
        }
        UIGraphicsPushContext(context)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(buffer, [])
        return buffer
    }
}
