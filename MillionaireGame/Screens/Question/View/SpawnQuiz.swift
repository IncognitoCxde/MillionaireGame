import SwiftUI
import DesignSystem
import ConfettiSwiftUI

struct SpawnQuiz: View {
    
    @StateObject private var viewModel = QuizViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                if !viewModel.gameOver {
                    
                    QuestionHeaderView(
                        questionNumber: viewModel.currentQuestionIndex + 1,
                        prizeValue: viewModel.currentQuestion.prize
                    )
                    
                    .padding(.top, -40)
                    
                    TimerView(
                        remainingTime: $viewModel.remainingTime,
                        onTimeUp: {
                            viewModel.gameOver = true
                            viewModel.allCorrect = false
                        }
                    )
                    .padding(.bottom, 10)
                    
                    if viewModel.currentQuestionIndex < viewModel.questions.count {
                        let currentQuestion = viewModel.currentQuestion
                        
                        Text(currentQuestion.question)
                            .font(.title)
                            .padding()
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        
                        ForEach(currentQuestion.options.indices, id: \.self) { index in
                            let optionLabel = ["A: ", "B: ", "C: ", "D: "][index]
                            
                            AnswerOptionRow(
                                optionLabel: optionLabel,
                                optionText: currentQuestion.options[index],
                                gradient: viewModel.selectedAnswerIndex == index
                                ? (viewModel.selectedAnswerIsCorrect == true
                                   ? LinearGradient.correctGradient
                                   : LinearGradient.wrongGradient)
                                : LinearGradient.answerGradient,
                                action: {
                                    if !viewModel.isAnswerSelected {
                                        viewModel.checkAnswer(selectedIndex: index)
                                    }
                                }
                            )
                            .padding(5)
                            .disabled(viewModel.isAnswerSelected)
                        }
                        LifelineButtonSpawn()
                            .padding(.top, 30)
                    }
                    
                } else {
                    
                    if viewModel.allCorrect {
                        Text("🎊 YOU WIN 🎊")
                            .font(.largeTitle)
                            .padding()
                            .foregroundColor(.brightGold)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text("Congratulations!")
                            .font(.title)
                            .padding()
                            .foregroundColor(.brightGold)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                                                
                        let withdrawGradient = LinearGradient(
                            colors: [Color.green, Color.blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        
                        
                        HStack {
                            Image.coin
                                .resizable()
                                .frame(width: 50, height: 50)
                            Text("$ 1000,000")
                                .font(.largeTitle)
                                .padding()
                                .foregroundColor(.brightGold)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            
                        }
                        
                        Text("Click below to withdraw your cash now!")
                            .font(.title2)
                            .padding()
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                        
                        
                        SlantedButton(
                            title: "Withdraw Cash",
                            gradient: withdrawGradient,
                            action: {
                                print("Cash Withdrawn")
                            }
                        )
                            
                        .padding(.top)
                        
                    } else {
                        Text("Game Over")
                            .font(.largeTitle)
                            .padding()
                            .foregroundStyle(.white)
                        
                        let restartGradient = LinearGradient(
                            colors: [.brightGold, .darkGold],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        
                        SlantedButton(
                            title: "Restart Quiz",
                            gradient: restartGradient,
                            action: {
                                viewModel.restartQuiz()
                            }
                        )
                        .padding(.top)
                    }
                    
                }
            }
            ConfettiCannon(
                trigger: $viewModel.confettiCounter,
                num: 50,
                radius: 600
            )
        }
        .padding()
        .onAppear {
            viewModel.loadData()
        }
    }
}
