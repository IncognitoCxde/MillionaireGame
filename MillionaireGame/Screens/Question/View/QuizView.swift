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
    
    @ObservedObject var viewModel = QuizViewModel()
    
    
    var body: some View {
        ZStack {
            GameBackgroundView()
            VStack {
                SpawnQuiz(
                    viewModel: viewModel,
                    enableChat: $enableChat,
                    enablePhoneAFriend: $enablePhoneAFriend,
                )
                .environmentObject(viewModel)
                    .overlay(
                        Group {
                            if showChatPopUp {
                                ChatPopUpView(chatID: "test_chat_ID", isChatTimerActive: $isChatTimerActive, onClose: {
                                    self.showChatPopUp = false
                                }, viewModel: ChatViewModel(chatID: "test_chat_ID"))
                            }
                        }
                    )
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                        viewModel.restartQuiz()
                        viewModel.stopTimer()
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
