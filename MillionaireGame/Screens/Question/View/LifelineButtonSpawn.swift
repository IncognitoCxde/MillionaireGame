import SwiftUI
import DesignSystem

struct LifelineButtonSpawn: View {
    
    @ObservedObject var viewModel: QuizViewModel
    
    var onAudienceUsed: () -> Void = {}
    var onPhoneUsed: () -> Void = {}
    
    var body: some View {
        HStack(spacing: 15) {
            
            LifelineButton(gradient: .lifelineBlue, content: {
                Text("50:50")
            }) {
                if !viewModel.usedFiftyFifty {
                    viewModel.useFiftyFifty()
                }
            }
            .opacity(viewModel.usedFiftyFifty ? 0.5 : 1.0)
            .disabled(viewModel.usedFiftyFifty)

            
            LifelineButton(gradient: .lifelineBlue, content: {
                Image.community
            }) {
                if !viewModel.usedAskAudience {
                    viewModel.useAskAudience()
                    onAudienceUsed()
                }
            }
            .opacity(viewModel.usedAskAudience ? 0.5 : 1.0)
            .disabled(viewModel.usedAskAudience)

            
            LifelineButton(gradient: .lifelineBlue, content: {
                Image.phone
            }) {
                if !viewModel.usedPhoneAFriend {
                    viewModel.usePhoneAFriend()
                    onPhoneUsed()
                }
            }
            .opacity(viewModel.usedPhoneAFriend ? 0.5 : 1.0)
            .disabled(viewModel.usedPhoneAFriend)
        }
    }
}
