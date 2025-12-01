import SwiftUI

struct PhoneAnimationView: View {
    @Binding var showAnimation: Bool
    var message: String
    
    var body: some View {
        VStack {
            Text("Phone Call")
                .font(.title)
                .fontWeight(.bold)
            
            Image.phone
                .resizable()
                .frame(width: 50, height: 50)
                .rotationEffect(.degrees(45))
                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true))
            
            Text(message)
                .font(.title2)
                .padding()
        }
        .frame(maxWidth: 300, maxHeight: 300)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
        .opacity(showAnimation ? 1 : 0)
    }
}
