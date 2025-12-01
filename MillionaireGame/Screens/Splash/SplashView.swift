// - Splash View Benazir M.

import SwiftUI
import DesignSystem

struct SplashView: View {
    
    @State private var isActive = false
    @State private var opacity: Double = 1.0
    
    var body: some View {
        NavigationStack {
            ZStack {
                if !isActive {
                    GameBackgroundView()
                    JustLogoView()
                        .opacity(opacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation(.easeOut(duration: 1.0)) {
                                    opacity = 0.0
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    withAnimation {
                                        isActive = true
                                    }
                                }
                            }
                        }
                } else {
                    HomeView()
                        .transition(.opacity)
                }
            }
        }
    }
}


#Preview {
    SplashView()
}
