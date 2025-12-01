import SwiftUI
import DesignSystem

struct AudiencePopUpView: View {
    @Binding var showPopUp: Bool
    var audienceVotes: [String: Int]
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Audience Vote")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            ForEach(audienceVotes.keys.sorted(), id: \.self) { option in
                Text("\(option): \(audienceVotes[option] ?? 0)%")
                    .font(.title2)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
            }
        }
        .padding(25)
        .background(
            Color.black.opacity(0.85)
        )
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.8), radius: 20, x: 0, y: 0)
        .shadow(color: .white.opacity(0.7), radius: 40)
        .opacity(showPopUp ? 1 : 0)
        .animation(.easeInOut, value: showPopUp)
    }
}
