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
                        JustLogoView()
                            .padding(.top, -80)
                        Text("YOU WIN")
                            .font(.largeTitle)
                            .padding()
                            .foregroundColor(.brightGold)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.top, -110)
                        Text("Congratulations!")
                            .font(.title)
                            .padding()
                            .foregroundColor(.brightGold)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .padding(.top, -80)

                        let withdrawGradient = LinearGradient(
                            colors: [.brightGold, .darkGold],
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
                            .font(.title3)
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
                        .frame(width: 400, height: 50)
                        .padding(.bottom, 90)
                        .padding(.top)
                        
                    } else {
                        JustLogoView()
                            .padding(.top, -80)
                        Text("Game Over")
                            .font(.largeTitle)
                            .padding()
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                            .padding(.top, -140)
                        
                        let restartGradient = LinearGradient(
                            colors: [.brightGold, .darkGold],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        
                        BestScoreSection(bestScore: viewModel.currentScore)
                            .padding(.bottom, 40)
                            .padding(.top, -60)
                        
                        VStack {
                            SlantedButton(
                                title: "Restart Quiz",
                                gradient: restartGradient,
                                action: {
                                    viewModel.restartQuiz()
                                }
                            )
                            .frame(width: 400, height: 50)
                            .padding(.bottom, 40)
                            SlantedButton(
                                title: "Back to Home",
                                gradient: .lifelineBlue,
                                action: {
                                }
                                
                            )
                            .frame(width: 400, height: 50)
                        }
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
