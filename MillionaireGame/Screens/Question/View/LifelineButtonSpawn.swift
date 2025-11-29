
import SwiftUI
import DesignSystem

struct LifelineButtonSpawn: View {
    var body: some View {
        HStack(spacing: 15) {
            LifelineButton(gradient: .lifelineBlue, content: {
                Text("50:50")
            }) {
                
            }
            
            LifelineButton(gradient: .lifelineBlue, content: {
                Image.community
            }) {
                
            }
            LifelineButton(gradient: .lifelineBlue, content: {
                Image.phone
            }) {
                
            }
        }
    }
}
