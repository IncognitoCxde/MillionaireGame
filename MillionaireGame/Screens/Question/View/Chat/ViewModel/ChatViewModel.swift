import FirebaseDatabase
import SwiftUI

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var chatText: String = ""
    private var ref: DatabaseReference
    private var chatID: String

    struct ChatMessage: Identifiable {
        var id = UUID()
        var message: String
        var isSent: Bool
    }

    init(chatID: String) {
        self.ref = Database.database().reference()
        self.chatID = chatID
        loadMessages()
    }

    func loadMessages() {
        ref.child("chats").child(chatID).observe(.childAdded) { snapshot in
            if let messageData = snapshot.value as? [String: Any],
               let message = messageData["message"] as? String {
                let newMessage = ChatMessage(message: message, isSent: false)
                if !self.messages.contains(where: { $0.message == newMessage.message }) {
                    DispatchQueue.main.async {
                        self.messages.append(newMessage)
                    }
                }
            }
        }
    }

    func handleSend() {
        let message = chatText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !message.isEmpty {
            let messageData: [String: Any] = [
                "message": message,
                "timestamp": Int(Date().timeIntervalSince1970)
            ]
            ref.child("chats").child(chatID).childByAutoId().setValue(messageData) { error, _ in
                if let error = error {
                    print("Error sending message: \(error.localizedDescription)")
                } else {
                    print("Message sent successfully!")
                }
            }
            let newMessage = ChatMessage(message: message, isSent: true)
            self.messages.append(newMessage)
            chatText = ""
        }
    }
}
