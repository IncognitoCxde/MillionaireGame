// - Home View Benazir M.

import SwiftUI
import DesignSystem

struct HomeView: View {
    
    @State private var goToQuiz = false
    @State private var showRules = false
    @State private var showSettingsSheet = false
    @State private var enableChat = false
    @State private var enablePhoneAFriend = false
    
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
                .navigationDestination(isPresented: $goToQuiz) {
                    QuizView(enableChat: $enableChat, enablePhoneAFriend: $enablePhoneAFriend)
                }
                
                .sheet(isPresented: $showRules) {
                    RulesView()
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                }
                .sheet(isPresented: $showSettingsSheet) {
                    SettingsSheet(enableChat: $enableChat, enablePhoneAFriend: $enablePhoneAFriend)
                        .presentationDetents([.fraction(0.20), .medium])
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showRules = true
                        }) {
                            Image.help
                                .padding(.trailing, 20)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            showSettingsSheet = true
                        }) {
                            Image(systemName: "gearshape.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(.leading, 20)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
