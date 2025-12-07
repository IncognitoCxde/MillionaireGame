import SwiftUI

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
            
            Text("Time remaining: \(remainingTime)s")
                .font(.title2)
                .padding(.bottom)
                .foregroundColor(remainingTime <= 5 ? .red : .black)
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewModel.messages) { message in
                        HStack {
                            if message.isSent {
                                Spacer()
                                Text(message.message)
                                    .padding(10)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.bottom, 5)
                            } else {
                                Text(message.message)
                                    .padding(10)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(10)
                                    .padding(.bottom, 5)
                                Spacer()
                            }
                        }
                    }
                }
                .padding()
            }
            
            HStack {
                TextField("Type your message...", text: $viewModel.chatText)
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
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top)
        }
        .frame(width: 300, height: 400)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
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
