import SwiftUI
import DesignSystem

struct QuizView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var enableChat: Bool
    @Binding var enablePhoneAFriend: Bool
    
    @State private var showChatPopUp = false
    @State private var isChatTimerActive = false
    @State private var showAudiencePopUp = false
    @State private var showPhoneAnimation = false
    
    var body: some View {
        ZStack {
            GameBackgroundView()
            VStack {
                SpawnQuiz(
                    enableChat: $enableChat,
                    enablePhoneAFriend: $enablePhoneAFriend
                )
                    .overlay(
                        Group {
                            if showChatPopUp {
                                ChatPopUpView(isChatTimerActive: $isChatTimerActive, onClose: {
                                    self.showChatPopUp = false
                                })
                            }
                        }
                    )
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image.arrowBack
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}
