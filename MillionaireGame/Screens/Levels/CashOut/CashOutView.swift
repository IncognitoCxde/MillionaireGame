import SwiftUI
import DesignSystem

struct CashOutView: View {
    var body: some View {
        ZStack {
            GameBackgroundView()
            VStack {
                Text("Congratulations!")
                    .font(.largeTitle)
                    .foregroundColor(.brightGold)
                    .padding()

                Text("You've reached the Cash Out stage!")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()

                Button(action: {
                    print("Cash Out Button Tapped!")
                }) {
                    Text("Confirm Cash Out")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(LinearGradient(colors: [.brightGold, .darkGold], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .frame(width: 250, height: 50)
                }
                .padding(.top, 50)
            }
        }
    }
}

#Preview {
    CashOutView()
}
