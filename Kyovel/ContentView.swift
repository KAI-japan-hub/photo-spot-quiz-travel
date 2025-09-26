//
//  ContentView.swift
//  Kyovel
//
//  Created by Shosei Yamaguchi on 2025/04/30.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var locationViewModel = LocationViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                // ★ Simple gradient background
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
                    Text("Thank you for participating in this experiment!")
                        .multilineTextAlignment(.center)
                        .padding()

                    NavigationLink(destination: NextView()) {
                        Text("Proceed to next: Consent Given")
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
                // ✅ App logo (assuming AppLogo.png is added to Assets)
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 5)

                Text("・If you want to review the experiment instruction, please refer to the procedure manual. If you're ready to begin the experiment, proceed to the destination confirmation screen.")
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)

                // Buttons (unchanged)
                NavigationLink(destination: Instruction()) {
                    Text("Experiment Manual")
                        .foregroundColor(.black)
                        .frame(width: 280, height: 50)
                        .background(Color.cyan)
                        .cornerRadius(25)
                }

                // Personality test button
                Link(destination: URL(string: "https://docs.google.com/forms/d/e/1FAIpQLScZpNl_uz1Q3vugUzVJyAmbv-7MSozgtIZyeJ7kWqCWJ8KD7A/viewform?usp=header")!) {
                    Text("Personality Test (Day 1 only)")
                        .foregroundColor(.white)
                        .frame(width: 280, height: 50)
                        .background(Color.purple)
                        .cornerRadius(25)
                }
                .padding(.bottom, 20)

                NavigationLink(destination: MapExplanation()) {
                    Text("Destination Confirmation")
                        .foregroundColor(.black)
                        .frame(width: 280, height: 50)
                        .background(Color.mint)
                        .cornerRadius(25)
                }

                NavigationLink(destination: RouletteDestinationView(locationViewModel: locationViewModel)) {
                    Text("Decide Destination Randomly!")
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
            Color(.systemGray6).ignoresSafeArea() // ★ Light gray background

            VStack(spacing: 30) {
                Text("Decide your next destination from the map.")
                Text("Please choose your next destination from the map.")
                    .multilineTextAlignment(.center)

                NavigationLink(destination: MapView()) {
                    Text("Next")
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
