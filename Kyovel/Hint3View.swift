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

struct Hint3View: View {
    let spotName: String

    /// Final hints per spot (EN keys).
    private let hints: [String: [String]] = [
        "Fushimi Inari Taisha": [
            "Veer left to a small side shrine near a bend.",
            "Keep the torii rhythm filling the background.",
            "Subject stands 2–3 meters from you."
        ],
        "Arashiyama Bamboo Grove": [
            "Find an S-curve in the path for depth.",
            "Place horizon low; emphasize vertical bamboo.",
            "Wait for a brief gap in foot traffic."
        ],
        "Kinkaku-ji": [
            "Use a tree branch to frame the top edge.",
            "Keep reflections clear by stepping back.",
            "Slight diagonal tilt adds dynamism."
        ],
        "To-ji Temple": [
            "Align the pagoda center-left in frame.",
            "Include ripples as texture in the pond.",
            "Avoid direct sun in lens for contrast."
        ],
        "Heian Shrine": [
            "Step back to include both bridge and pavilion.",
            "Let the bridge arc guide eye to the center.",
            "A polarizer may help tame reflections."
        ],
        "Kiyomizu-dera": [
            "Add foreground leaves at the top corners.",
            "Keep the hall slightly off-center.",
            "Early morning yields softer light."
        ],
        "Kennin-ji": [
            "Balance corridor lines with garden openness.",
            "Avoid strong backlight; expose for wood tones.",
            "Keep verticals straight (no keystone)."
        ],
        "Kyoto Int’l Manga Museum": [
            "Frame signage plus a portion of the facade.",
            "Keep lines level to avoid distortion.",
            "If indoors, mind visitors’ privacy."
        ],
        "Nijo Castle": [
            "Use a corner where wall meets moat for depth.",
            "Include a small tree cluster as a counterweight.",
            "Try a slightly elevated stance if possible."
        ],
        "Kyoto City Kyocera Museum": [
            "Center yourself on the stair spine.",
            "Include sky for contrast over the facade.",
            "Wait for minimal foot traffic."
        ],
        "Shimogamo Shrine": [
            "Angle so torii and lanterns share the frame.",
            "Keep creek parallel to the lower edge.",
            "Overcast light works well for color."
        ],
        "Randen Arashiyama Station": [
            "Compose through two pole rows as a tunnel.",
            "Let lights form a bokeh trail.",
            "Stabilize the camera for cleaner night shots."
        ],
        "Kyoto Sangyo University": [
            "Include both the gate and a campus landmark.",
            "Keep text (signage) horizontal for readability.",
            "Consider late afternoon for warmer tones."
        ]
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hint 3")
                .font(.title3)
                .fontWeight(.semibold)

            let key = normalizeSpotName(spotName)
            if let list = hints[key], !list.isEmpty {
                ForEach(list, id: \.self) { hint in
                    Text("• \(hint)")
                }
            } else {
                Text("Final tip: check for a landmark line-of-sight and re-create the perspective from the quiz image.")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .navigationTitle(spotName)
    }
}
