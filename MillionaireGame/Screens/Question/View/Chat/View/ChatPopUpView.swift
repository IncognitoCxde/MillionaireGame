import SwiftUI
import DesignSystem

struct ChatPopUpView: View {
    
    @Binding var isChatTimerActive: Bool
    var onClose: () -> Void
    
    @ObservedObject private var viewModel: ChatViewModel
    @ObservedObject private var quizVM = QuizViewModel()
    @State private var remainingTime: Int = 30
    @State private var timer: Timer?
    
    init(chatID: String, isChatTimerActive: Binding<Bool>, onClose: @escaping () -> Void, viewModel: ChatViewModel) {
        self._isChatTimerActive = isChatTimerActive
        self.onClose = onClose
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Text("Chat with a Friend")
                .font(.title)
                .padding(.top)
                .foregroundStyle(.white)
                .fontWeight(.semibold)
            
            Text("Time remaining: \(remainingTime)s")
                .font(.title2)
                .padding(.bottom)
                .foregroundColor(remainingTime <= 5 ? .red : .white)
                .fontWeight(.semibold)
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewModel.messages) { message in
                        HStack {
                            if message.isSent {
                                Spacer()
                                Text(message.message)
                                    .fontWeight(.semibold)
                                    .padding(10)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.bottom, 5)
                            } else {
                                Text(message.message)
                                    .padding(10)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .padding(.bottom, 5)
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                        }
                    }
                }
                .padding()
            }
            
            HStack {
                TextField("Type here...", text: $viewModel.chatText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                Button(action: {
                    viewModel.handleSend()
                }) {
                    Text("Send")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            
            Button(action: {
                stopTimer()
                quizVM.chatUsed = true
                onClose()
            }) {
                Text("Close Chat")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.red)
                    .fontWeight(.semibold)
            }
            .padding(.top)
        }
        .frame(width: 300, height: 400)
        .background(Color.black.opacity(0.85))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.8), radius: 20)
        .shadow(color: .white.opacity(0.7), radius: 40)
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
            quizVM.chatUsed = true
        }
    }
    
    private func startTimer() {
        remainingTime = 30
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                self.stopTimer()
                quizVM.chatUsed = true
                onClose()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
    }
}
