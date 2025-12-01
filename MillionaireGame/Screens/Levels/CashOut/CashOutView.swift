import SwiftUI
import DesignSystem

struct CashOutView: View {
    
    @StateObject private var viewModel = QuizViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            GameBackgroundView()
            VStack {
                JustLogoView()
                
                Text("Cash Out Early")
                    .font(.largeTitle)
                    .foregroundColor(.brightGold)
                    .padding()
                    .fontWeight(.bold)
                    .padding(.top, -100)

                Text("Take your winnings early!")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .multilineTextAlignment(.center)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .padding(.top, -30)
                
                Text("Are you sure?")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .multilineTextAlignment(.center)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .padding(.top, -30)
                
                SlantedButton(title: "Confirm Cash Out", gradient: LinearGradient(colors: [.brightGold, .darkGold], startPoint: .leading, endPoint: .trailing)) {
                    
                }
                .frame(width: 400, height: 50)
                .padding(.bottom, 100)
                .padding(.top, 60)
            }
            .navigationBarBackButtonHidden(true)
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                       dismiss()
                    }) {
                        Image.arrowBack
                    }
                }
            }
        }
    }
}
