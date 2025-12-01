import SwiftUI

struct PhoneAnimationView: View {
    @Binding var showAnimation: Bool
    var message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Phone a Friend")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Image.phone
                .resizable()
                .frame(width: 60, height: 60)
                .rotationEffect(.degrees(showAnimation ? 0 : -20))
                .animation(.easeInOut(duration: 0.6).repeatForever(), value: showAnimation)
            
            Text("Hey, glad you called me!")
                .foregroundColor(.white)
                .font(.title3)
                .padding(.top, 5)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            Text(message)
                .foregroundColor(.white)
                .font(.title3)
                .padding(.top, 5)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
        }
        .padding(25)
        .background(Color.black.opacity(0.85))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.8), radius: 20)
        .shadow(color: .white.opacity(0.7), radius: 40)
        .opacity(showAnimation ? 1 : 0)
        .animation(.easeInOut, value: showAnimation)
    }
}
