// - Home View

import SwiftUI
import DesignSystem

struct HomeView: View {
    var body: some View {
        ZStack {
            GameBackgroundView()
            VStack {
                MainLogoView()
                    .padding(.top, -90)
                    .padding(.bottom, 60)
                SlantedButton(title: "New Game", gradient: LinearGradient(colors: [.brightGold, .darkGold], startPoint: .top, endPoint: .bottom)) {
                    
                }
                .frame(width: 400, height: 50)
                .padding(.top, 50)
            }
        }
    }
}

#Preview {
    HomeView()
}
