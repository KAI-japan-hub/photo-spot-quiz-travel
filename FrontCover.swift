import SwiftUI

struct FrontCover: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Thank you for participating in the experiment!")
            Text("This study investigates whether communication enhances group travel enjoyment.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

#Preview {
    FrontCover()
}
