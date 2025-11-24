// - Splash View

import SwiftUI
import DesignSystem

struct SplashView: View {
    
    @State private var isActive = false
    @State private var opacity: Double = 1.0
    
    var body: some View {
        ZStack {
            GameBackgroundView()
            
            VStack {
                JustLogoView()
            }
            .opacity(opacity)
            
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.easeOut(duration: 1.0)) {
                        opacity = 0.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        isActive = true
                    }
                }
            }
            if isActive {
                HomeView()
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 1.0), value: isActive)
    }
}

#Preview {
    SplashView()
}
