//
//  SpotAnswer.swift
//  KaiKai
//
//  Created by 山口翔生 on 2025/06/04.
//
//位置情報が特定できなかった際に、答えとして位置情報を提供するファイル

import SwiftUI
import CoreLocation
import simd
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Vision

struct SpotAnswer: View {
    let spotName: String
    
    private let spotLocations: [String: CLLocationCoordinate2D] = [
        "清水寺": CLLocationCoordinate2D(latitude: 34.9948, longitude: 135.7850),
        "東福寺": CLLocationCoordinate2D(latitude: 34.9774963, longitude: 135.7732795),
        "嵐山の竹林": CLLocationCoordinate2D(latitude: 35.0176438, longitude: 135.6740559),
        "京都御所": CLLocationCoordinate2D(latitude: 35.0219461, longitude: 135.7632605),
        "東本願寺": CLLocationCoordinate2D(latitude: 34.9932465, longitude: 135.7577311),
        "京都産業大学":CLLocationCoordinate2D(latitude: 35.0697856, longitude: 135.7568416),
        "上賀茂神社":CLLocationCoordinate2D(latitude: 35.0596640, longitude: 135.7530852),
        "錦市場":CLLocationCoordinate2D(latitude: 35.0050351, longitude: 135.7656084),
        "南禅寺":CLLocationCoordinate2D(latitude: 35.0111936, longitude: 135.7940516),
        "哲学の道":CLLocationCoordinate2D(latitude: 35.0187537, longitude: 135.7945243),
        "京都市京セラ美術館":CLLocationCoordinate2D(latitude: 35.013413, longitude: 135.7835856),
        "伏見稲荷大社":CLLocationCoordinate2D(latitude: 34.9668720, longitude: 135.7753653),
        "京都駅":CLLocationCoordinate2D(latitude: 34.985847, longitude: 135.75988),
    ]
    var body: some View {
        Text(spotLocations[spotName].map { "緯度: \($0.latitude), 経度: \($0.longitude)" } ?? "スポットが見つかりません")
            .padding(.horizontal)

    }
}

