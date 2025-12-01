import SwiftUI
import DesignSystem

struct LevelProgressView: View {
    let levels: [(Int, String)]
    let currentLevel: Int
    
    var body: some View {
        ZStack {
            GameBackgroundView()
            VStack(spacing: -80) {
                Image.appLogo
                    .resizable()
                    .frame(width: 150, height: 150)
                
                VStack(spacing: 55) {
                    ForEach(levels.reversed(), id: \.0) { level in
                        PrizeRow(
                            leftText: "\(level.0):",
                            rightText: level.1,
                            gradient: (level.0 == 10 || level.0 == 5) ? .prizeBlue : (level.0 == currentLevel ? .prizeGreen : .lifelineBlue)
                        )
                        .frame(width: 400, height: 0)
                        .animation(.easeInOut(duration: 0.5), value: currentLevel)
                    }
                }
                .scaleEffect(0.8)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        
                    }){
                        Image.cashOut
                    }
                }
            }
        }
    }
}
