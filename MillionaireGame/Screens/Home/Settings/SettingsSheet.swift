import SwiftUI

struct SettingsSheet: View {
    @Binding var enableChat: Bool
    @Binding var enablePhoneAFriend: Bool

    var body: some View {
        VStack(spacing: 30) {
            Toggle(isOn: $enableChat) {
                Text("Enable Chat")
            }
            .onChange(of: enableChat) { newValue in
                if newValue {
                    enablePhoneAFriend = false
                }
            }

            Toggle(isOn: $enablePhoneAFriend) {
                Text("Enable Phone A Friend")
            }
            .onChange(of: enablePhoneAFriend) { newValue in
                if newValue {
                    enableChat = false
                }
            }
        }
        .padding()
        .onAppear {
            if !enableChat && !enablePhoneAFriend {
                enablePhoneAFriend = true
            }
        }
    }
}
