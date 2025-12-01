import SwiftUI
import DesignSystem

struct QuizView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            GameBackgroundView()
            VStack {
                SpawnQuiz()
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        
                    }) {
                        Image.levels
                    }
                }
            }
        }
    }
}

#Preview {
    QuizView()
}
