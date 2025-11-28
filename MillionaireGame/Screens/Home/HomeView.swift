// - Home View Benazir M.

import SwiftUI
import DesignSystem

struct HomeView: View {
    
    @State private var goToQuiz = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                GameBackgroundView()
                
                VStack {
                    MainLogoView()
                        .padding(.top, -160)
                        .padding(.bottom, 60)
                    
                    SlantedButton(title: "New Game", gradient: LinearGradient(colors: [.brightGold, .darkGold], startPoint: .leading, endPoint: .trailing)) {
                        goToQuiz = true
                    }
                    .frame(width: 400, height: 50)
                    .padding(.top, 50)
                    
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            print("Help Tapped...")
                        }) {
                            Image.help
                                .padding(.trailing, 20)
                        }
                    }
                    
                    
                }
            }
            
            .navigationDestination(isPresented: $goToQuiz) {
                QuizView()
            }
        }
    }
}

#Preview {
    HomeView()
}
