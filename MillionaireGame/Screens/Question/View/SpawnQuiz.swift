import SwiftUI
import DesignSystem
import ConfettiSwiftUI

struct SpawnQuiz: View {
    
    @ObservedObject var viewModel: QuizViewModel
    
    @State private var showLevelsScreen = false
    @State private var opacity: Double = 1.0
    @Environment(\.dismiss) var dismiss
    
    @State private var showAudiencePopUp = false
    @State private var showPhoneAnimation = false
    
    @Binding var enableChat: Bool
    @Binding var enablePhoneAFriend: Bool
    
    @State private var showChatPopUp = false
    @State private var isChatTimerActive = false
    
    @State private var showGameEndScreen = false
    
    @State private var isNavigating = false
    
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
                            
                            if viewModel.usedFiftyFifty && !viewModel.availableOptions.contains(index) {
                                EmptyView()
                                    .frame(height: 0)
                            } else {
                                AnswerOptionRow(
                                    optionLabel: optionLabel,
                                    optionText: currentQuestion.options[index],
                                    gradient: viewModel.selectedAnswerIndex == index
                                    ? (
                                        viewModel.selectedAnswerIsCorrect!
                                        ? LinearGradient.correctGradient
                                        : LinearGradient.wrongGradient
                                    )
                                    : LinearGradient.answerGradient,
                                    action: {
                                        if !viewModel.isAnswerSelected {
                                            viewModel.checkAnswer(selectedIndex: index)
                                            withAnimation(.easeInOut(duration: 2.0)) {
                                                opacity = 0.0
                                                showLevelsScreen = true
                                            }
                                        }
                                    }
                                )
                                .padding(5)
                                .disabled(viewModel.isAnswerSelected)
                            }
                        }
                        
                        LifelineButtonSpawn(
                            viewModel: viewModel,
                            onAudienceUsed: {
                                showAudiencePopUp = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    withAnimation {
                                        showAudiencePopUp = false
                                    }
                                }
                            }, enableChat: $enableChat,
                            enablePhoneAFriend: $enablePhoneAFriend,
                            onChatUsed: {
                                showChatPopUp = true
                                viewModel.chatUsed = true
                                viewModel.stopTimer()
                            },
                            onPhoneUsed: {
                                showPhoneAnimation = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    withAnimation {
                                        showPhoneAnimation = false
                                    }
                                }
                            }
                        )
                        .padding(.top, 30)
                    }
                    
                } else {
                    if showGameEndScreen {
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
                                    isNavigating = true
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
                                        dismiss()
                                    }
                                )
                                .frame(width: 400, height: 50)
                            }
                        }
                    }
                }
            }
            NavigationLink(destination: CardDetailsView(), isActive: $isNavigating) {
                EmptyView()
            }
            .overlay(
                AudiencePopUpView(showPopUp: $showAudiencePopUp, audienceVotes: viewModel.audienceVotes)
                    .transition(.opacity)
            )
            
            .overlay(
                PhoneAnimationView(showAnimation: $showPhoneAnimation, message: viewModel.phoneCallMessage)
                    .transition(.opacity)
            )
            
            ConfettiCannon(
                trigger: $viewModel.confettiCounter,
                num: 50,
                radius: 600
            )
            
            if showChatPopUp {
                ChatPopUpView(
                    chatID: "test_chat_ID", isChatTimerActive: $isChatTimerActive,
                    onClose: {
                        self.showChatPopUp = false
                        viewModel.startTimer()
                    }, viewModel: ChatViewModel(chatID: "test_chat_ID")
                )
                .transition(.opacity)
            }
            
            if showLevelsScreen {
                LevelProgressView(
                    levels: [(1, "$500"), (2, "$1,000"), (3, "$2,000"), (4, "$3,000"), (5, "$5,000"), (6, "$7,500"), (7, "$10,000"), (8, "$12,500"), (9, "$15,000"), (10, "$25,000"), (11, "$50,000"), (12, "$100,000"), (13, "$250,000"), (14, "$500,000"), (15, "$1,000,000")],
                    currentLevel: viewModel.currentQuestionIndex + 1,
                    viewModel: viewModel
                )
                .navigationBarHidden(true)
                .transition(.opacity)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            opacity = 1
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                showLevelsScreen = false
                                withAnimation {
                                    showGameEndScreen = true
                                }
                            }
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            viewModel.nextQuestion()
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: LevelProgressView(levels: [(1, "$500"), (2, "$1,000"), (3, "$2,000"), (4, "$3,000"), (5, "$5,000"), (6, "$7,500"), (7, "$10,000"), (8, "$12,500"), (9, "$15,000"), (10, "$25,000"), (11, "$50,000"), (12, "$100,000"), (13, "$250,000"), (14, "$500,000"), (15, "$1,000,000")], currentLevel: viewModel.currentQuestionIndex + 1, viewModel: viewModel)) {
                    Image.levels
                }
            }
        }
        .padding()
        .onAppear {
            viewModel.loadData()
        }
    }
}

