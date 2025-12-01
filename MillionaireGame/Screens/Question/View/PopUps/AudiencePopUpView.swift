import SwiftUI
import DesignSystem

struct AudiencePopUpView: View {
    @Binding var showPopUp: Bool
    var audienceVotes: [String: Int]
    
    var body: some View {
        VStack {
            Text("Audience Vote")
                .font(.title)
                .fontWeight(.bold)
            
            ForEach(audienceVotes.keys.sorted(), id: \.self) { option in
                Text("\(option): \(audienceVotes[option] ?? 0)%")
                    .font(.title2)
                    .padding()
            }
            
            Button("Close") {
                showPopUp = false
            }
            .padding()
        }
        .frame(maxWidth: 300, maxHeight: 300)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
        .opacity(showPopUp ? 1 : 0)
    }
}
