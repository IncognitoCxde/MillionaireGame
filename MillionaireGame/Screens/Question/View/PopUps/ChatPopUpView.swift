import SwiftUI

struct ChatPopUpView: View {
    @Binding var isChatTimerActive: Bool
    var onClose: () -> Void
    
    @State private var remainingTime: Int = 30
    @State private var timer: Timer?
    
    var body: some View {
        VStack {
            Text("Chat with a Friend")
                .font(.title)
                .padding()
            
            Text("Time remaining: \(remainingTime)s")
                .font(.title2)
                .padding()
            
            Text("Type your question to get help!")
                .font(.body)
                .padding()
            
            
            
            Button("Close Chat") {
                stopTimer()
                onClose()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .frame(width: 300, height: 250)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .onAppear {
            startTimer()
        }
    }
    
    private func startTimer() {
        isChatTimerActive = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                stopTimer()
                onClose()
            }
        }
    }
    
    private func stopTimer() {
        isChatTimerActive = false
        timer?.invalidate()
    }
}
