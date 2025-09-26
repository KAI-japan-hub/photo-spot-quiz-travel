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

struct Hint2View: View {
    let spotName: String

    /// Secondary hints per spot (EN keys).
    private let hints: [String: [String]] = [
        "Fushimi Inari Taisha": [
            "After passing Okusha Shrine, stay on the main loop.",
            "Look for a short stone staircase on your left.",
            "The frame faces slightly southwest."
        ],
        "Arashiyama Bamboo Grove": [
            "Avoid the central junction; move 50–80m north.",
            "Compose with the rail fence at the bottom edge.",
            "Try portrait orientation for height."
        ],
        "Kinkaku-ji": [
            "Best from the far side of the pond path.",
            "Keep the pavilion in the upper-right quadrant.",
            "Avoid midday glare if possible."
        ],
        "To-ji Temple": [
            "Stand near the garden corner for symmetry.",
            "Use the pond as a foreground layer.",
            "Include the pagoda tip near the top edge."
        ],
        "Heian Shrine": [
            "Cross the bridge halfway and face the pavilion.",
            "Let the handrail lead the viewer’s eye.",
            "Keep the horizon slightly below center."
        ],
        "Kiyomizu-dera": [
            "Find a side terrace with fewer tourists.",
            "Wooden pillars should form vertical lines.",
            "Frame with foliage for depth."
        ],
        "Kennin-ji": [
            "Seek shaded corridor to avoid blown highlights.",
            "Include a garden window if visible.",
            "Use a 35–50mm equivalent focal length."
        ],
        "Kyoto Int’l Manga Museum": [
            "Indoor lighting: raise ISO slightly.",
            "Look for a clean background near exhibits.",
            "Avoid reflective glare on display cases."
        ],
        "Nijo Castle": [
            "Shoot along the moat with the stone wall side-on.",
            "Use a leading path from the lower-left.",
            "Keep people out of the center if possible."
        ],
        "Kyoto City Kyocera Museum": [
            "Center yourself at the main stairs landing.",
            "Aim for left–right symmetry in columns.",
            "A wide lens helps capture the facade."
        ],
        "Shimogamo Shrine": [
            "Face the torii with the stream on your right.",
            "Include tree shadows on the path.",
            "Try a slightly lower shooting height."
        ],
        "Randen Arashiyama Station": [
            "Angle along the kimono poles for a vanishing point.",
            "Evening blue hour enhances colors.",
            "Keep bright lights just out of frame to avoid flares."
        ],
        "Kyoto Sangyo University": [
            "Stand across the road from the main gate.",
            "Keep the campus name sign sharp.",
            "Use a mild wide angle to include sky and foreground."
        ]
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hint 2")
                .font(.title3)
                .fontWeight(.semibold)

            let key = normalizeSpotName(spotName)
            if let list = hints[key], !list.isEmpty {
                ForEach(list, id: \.self) { hint in
                    Text("• \(hint)")
                }
            } else {
                Text("No additional hint available here. Try adjusting your angle or moving 10–20 meters along the path.")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .navigationTitle(spotName)
    }
}
