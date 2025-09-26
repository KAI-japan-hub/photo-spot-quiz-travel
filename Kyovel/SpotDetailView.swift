import SwiftUI
import MapKit

struct SpotDetailView: View {
    let spotName: String
    @State private var capturedImage: UIImage?
    @State private var showingCamera = false
    @ObservedObject var locationViewModel: LocationViewModel
    
    // Dictionary for spot descriptions
    private let spotDetails: [String: String] = [
        "嵐山の竹林の道": "A mystical bamboo path with towering stalks forming a tunnel-like walkway.",
        "東福寺": "One of Kyoto’s Zen temples, famous for autumn leaves. Admission: 600 yen.",
        "南禅寺": "Founded in 1291 by a Zen monk. Rich in historical architecture and gardens.",
        "哲学の道": "A cherry blossom-lined walking path inspired by philosopher Nishida Kitaro.",
        "京都府立植物園": "A historic botanical garden with seasonal flowers and large greenhouses.",
        "錦市場": "Known as 'Kyoto’s kitchen', full of local food, gifts, and vibrant street life.",
        "祇園白川沿い": "A beautiful district with old streets and cherry blossoms along the Shirakawa river.",
        "京都駅": "Kyoto's iconic gateway and transportation hub.",
        "鴨川": "A popular riverside area with stepping stones and a triangular delta.",
        "上賀茂神社": "One of Kyoto’s oldest shrines and a UNESCO site. Known for protection and victory.",
        "京都御所": "Historic imperial palace with classic architecture from the Heian era.",
        "平安神宮と神苑": "Dedicated to Emperors Kanmu and Komei. Features a large scenic garden.",
        "清水寺": "A UNESCO temple with iconic wooden stage and important cultural assets.",
        "伏見稲荷大社": "Famous for its thousands of vermilion torii gates. Main shrine for Inari.",
        "京都国際マンガミュージアム": "Museum in a former school with over 300,000 manga. Read freely on the lawn.",
        "二条城": "Built by Tokugawa Ieyasu. Later became an imperial villa and now a World Heritage site.",
        "京都市京セラ美術館": "Historic museum showcasing Japanese paintings to modern art.",
        "下鴨神社": "UNESCO-listed shrine surrounded by primeval forest. Known for its sacred atmosphere.",
        "嵐電嵐山駅": "Famous for illuminated Kimono Forest displays at night.",
        "京都産業大学":"University"
    ]
    
    // Spot image dictionary (use appropriate asset names)
    private let spotImages: [String: String] = [
        "清水寺": "kiyomizu",
        "東福寺": "tohukuji",
        "京都御所": "kyotogosho",
        "嵐山の竹林の道": "chikurin",
        "錦市場": "nishikiichiba",
        "上賀茂神社": "kamigamo",
        "南禅寺": "nanzenji",
        "哲学の道": "tetsugaku",
        "京都駅": "kyotostation",
        "京都市京セラ美術館": "kyosera",
        "京都産業大学": "kyousan",
        "伏見稲荷大社": "hushimi"
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(spotName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                    .padding(.horizontal)
                
                // Spot image
                if let imageName = spotImages[spotName] {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                        .clipped()
                        .cornerRadius(12)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
                        .minimumScaleFactor(0.3)
                        .padding(.horizontal)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .overlay(
                            Text("No Image")
                                .foregroundColor(.gray)
                        )
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                
                // Description
                Text("Overview")
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                
                Text(spotDetails[spotName] ?? "No description available.")
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
                    .minimumScaleFactor(0.3)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Survey links
                Link(destination: URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSdUA7skUl17G6DDjtotbspcRnb6iXrBTNkFkVhoj4vszyU1Tg/viewform?usp=dialog")!) {
                    Text("Arrival Survey")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .cornerRadius(25)
                }
                .padding(.bottom, 20)
                
                Link(destination: URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSco6kpfZtdSotR6SgWYYOw_29WSOj-cY2YP_HsqTBxyTkC69Q/viewform?usp=header")!) {
                    Text("Mid Survey")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .cornerRadius(25)
                }
                .padding(.bottom, 20)
                
                Link(destination: URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSfbFFvDYekEL-tXHKe5vIa807nCuHBKoJQKmgHLyYwSjY28pA/viewform?usp=header")!) {
                    Text("Exit Survey")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .cornerRadius(25)
                }
                .padding(.bottom, 20)
                
                Text("Hints")
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                
                NavigationLink(destination: HintView(spotName: spotName)) {
                    Text("View Hint 1 (Checked by Person A)")
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color.cyan, in: RoundedRectangle(cornerRadius: 50))
                }
                .padding(.horizontal)
                
                NavigationLink(destination: Hint2View(spotName: spotName)) {
                    Text("View Hint 2 (Checked by Person B)")
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color.cyan, in: RoundedRectangle(cornerRadius: 50))
                }
                .padding(.horizontal)
                
                NavigationLink(destination: Hint3View(spotName: spotName)) {
                    Text("View Hint 3 (Checked by Person C)")
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color.cyan, in: RoundedRectangle(cornerRadius: 50))
                }
                .padding(.horizontal)
                
                NavigationLink(destination: PhotoVerificationView(spotName: spotName, spotId: spotName, locationViewModel: locationViewModel)) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Verify with Photo")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.green, in: RoundedRectangle(cornerRadius: 50))
                }
                .padding(.horizontal)
                
                // View correct location
                VStack(spacing: 20) {
                    NavigationLink(destination: SpotAnswer(spotName: spotName)) {
                        Text("Unable to identify? View correct location")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.yellow, in: RoundedRectangle(cornerRadius: 50))
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Spot Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CameraWrapperView: View {
    let spotName: String
    @Binding var capturedImage: UIImage?
    @State private var showingCamera = true
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            if showingCamera {
                Camera2View(spotName: spotName, image: $capturedImage, isPresented: $showingCamera)
            } else {
                Text("Photo captured")
                    .font(.title2)
                    .padding()
                
                Button("Go back") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            showingCamera = true
        }
        .onChange(of: showingCamera) { isShowing in
            // Add logic here if needed
        }
    }
}
