import SwiftUI

struct RulesView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.dark.ignoresSafeArea()
            VStack{
                HStack (spacing: -30){
                    Spacer()
                    Text("Rules")
                        .font(.title)
                        .bold()
                        .foregroundStyle(.white)
                    Spacer()
                    
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 16) {
                        Text("""
                            4️⃣ Each question has four options and only one is the true answer!
                            💸 Questions become more difficult as the prize increases!
                            🕡 You have 30 seconds to answer each question!
                            ✅ Answer all 15 questions correctly to win $ 1000,000!
                            """)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.leading)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                        .font(.title3)
                        
                        Text("""
                            Lifeline Buttons to help: 
                            🔵 50:50 – removes two incorrect choices!
                            📞 Phone a Friend – maybe they know!
                            👥 Ask the Audience – they will vote!
                            """)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.leading)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                        .font(.title3)
                    }
                }
            }
        }
    }
}
