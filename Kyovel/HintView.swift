import SwiftUI
import MapKit

/// Returns a standardized key for bilingual spot names (JP/EN -> EN key).
fileprivate func normalizeSpotName(_ name: String) -> String {
    let map: [String: String] = [
        // Photo-worthy / Nature
        "伏見稲荷大社": "Fushimi Inari Taisha",
        "Fushimi Inari Taisha": "Fushimi Inari Taisha",
        "嵐山・竹林の小径": "Arashiyama Bamboo Grove",
        "Arashiyama Bamboo Grove": "Arashiyama Bamboo Grove",
        "金閣寺": "Kinkaku-ji",
        "Kinkaku-ji": "Kinkaku-ji",
        "東寺": "To-ji Temple",
        "To-ji Temple": "To-ji Temple",
        "平安神宮と神苑": "Heian Shrine",
        "Heian Shrine": "Heian Shrine",
        "清水寺": "Kiyomizu-dera",
        "Kiyomizu-dera": "Kiyomizu-dera",
        "建仁寺": "Kennin-ji",
        "Kennin-ji": "Kennin-ji",

        // Arts / Experiences / Unique
        "京都国際マンガミュージアム": "Kyoto Int’l Manga Museum",
        "Kyoto Int’l Manga Museum": "Kyoto Int’l Manga Museum",
        "二条城": "Nijo Castle",
        "Nijo Castle": "Nijo Castle",
        "京都市京セラ美術館": "Kyoto City Kyocera Museum",
        "Kyoto City Kyocera Museum": "Kyoto City Kyocera Museum",
        "下鴨神社": "Shimogamo Shrine",
        "Shimogamo Shrine": "Shimogamo Shrine",
        "嵐電嵐山駅": "Randen Arashiyama Station",
        "Randen Arashiyama Station": "Randen Arashiyama Station",
        "京都産業大学": "Kyoto Sangyo University",
        "Kyoto Sangyo University": "Kyoto Sangyo University"
    ]
    return map[name] ?? name
}

struct HintView: View {
    let spotName: String

    /// Primary hints per spot (EN keys). Keep concise & useful.
    private let hints: [String: [String]] = [
        "Fushimi Inari Taisha": [
            "Follow the main torii path uphill.",
            "Look for a fork where the trail narrows.",
            "Photo spot is just past a small side shrine."
        ],
        "Arashiyama Bamboo Grove": [
            "Head toward the densest bamboo section.",
            "Listen for quieter areas away from the main crowd.",
            "The angle looks upward with converging bamboo lines."
        ],
        "Kinkaku-ji": [
            "Find the pond view where the pavilion reflects.",
            "Frame from the right-side promenade.",
            "Keep trees on the left edge of the frame."
        ],
        "To-ji Temple": [
            "Search near the five-storied pagoda viewpoint.",
            "Water surface reflection may be in frame.",
            "Low-angle composition is key."
        ],
        "Heian Shrine": [
            "Enter the garden and head toward the large pond.",
            "Bridge lines guide your composition.",
            "Look for stone lanterns near the water."
        ],
        "Kiyomizu-dera": [
            "Find the terrace view toward the main hall.",
            "Try a side path for a less crowded angle.",
            "Trees frame the architecture in the shot."
        ],
        "Kennin-ji": [
            "Zen garden side paths give the right angle.",
            "Wooden corridors in partial shade.",
            "A raked gravel pattern may be visible."
        ],
        "Kyoto Int’l Manga Museum": [
            "Exterior with signage in frame.",
            "Books wall area gives a unique texture.",
            "Shoot from a lower angle for depth."
        ],
        "Nijo Castle": [
            "Garden paths toward the moat.",
            "Keep a stone wall in the background.",
            "Look for a framed gate view."
        ],
        "Kyoto City Kyocera Museum": [
            "Modern facade with wide steps.",
            "Symmetry from the central axis.",
            "Watch reflections on glass panels."
        ],
        "Shimogamo Shrine": [
            "Vermilion gates with creek nearby.",
            "Look for a tree canopy over the path.",
            "Include hanging lanterns if possible."
        ],
        "Randen Arashiyama Station": [
            "Art-pole (kimono) corridor area.",
            "Night lighting creates strong highlights.",
            "Shoot diagonally along the poles."
        ],
        "Kyoto Sangyo University": [
            "Main gate or campus landmark in frame.",
            "Find an elevated point for a wide shot.",
            "Keep signage legible in the composition."
        ]
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hint 1")
                .font(.title3)
                .fontWeight(.semibold)

            let key = normalizeSpotName(spotName)
            if let list = hints[key], !list.isEmpty {
                ForEach(list, id: \.self) { hint in
                    Text("• \(hint)")
                }
            } else {
                // Robust fallback so the view never looks empty
                Text("No hint data for this spot yet. Try moving slightly and re-checking the surrounding viewpoint.")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .navigationTitle(spotName)
    }
}
