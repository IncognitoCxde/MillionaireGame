import SwiftUI
import DesignSystem
import ConfettiSwiftUI

class QuizViewModel: ObservableObject {
        
    @Published var questions: [Question] = []
    @Published var currentQuestionIndex = 0
    @Published var selectedAnswerIndex: Int? = nil
    @Published var selectedAnswerIsCorrect: Bool? = nil
    @Published var isAnswerSelected = false
    @Published var gameOver = false
    @Published var allCorrect = true

    @Published var remainingTime: Int = 30
    
    var timer: Timer?
    
    @Published var confettiCounter = 0
    
    func fireConfetti() { confettiCounter += 1 }
    
    init() {
        loadData()
    }
    
    func startTimer() {
        stopTimer()
        
        guard !gameOver else { return }
        
        remainingTime = 30
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                self.stopTimer()
                if !self.allCorrect {
                    self.gameOver = true
                }
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    var currentQuestion: Question {
        questions[currentQuestionIndex]
    }

    func loadData() {
        if let url = Bundle.main.url(forResource: "questions", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode([Question].self, from: data) {
            self.questions = decoded
        }
        
        startTimer()
    }

    func checkAnswer(selectedIndex: Int) {
        selectedAnswerIndex = selectedIndex
        let correct = "\(selectedIndex)" == currentQuestion.correct_answer
        selectedAnswerIsCorrect = correct
        isAnswerSelected = true
        
        if !correct {
            allCorrect = false
            stopTimer()
            gameOver = true
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.nextQuestion()
            }
        }
    }

    func nextQuestion() {
        guard selectedAnswerIsCorrect == true else { return }
        guard !gameOver else { return }
        
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            resetAnswerState()
            startTimer()
        } else {
            allCorrect = true
            gameOver = true
            stopTimer()
            fireConfetti()
            resetAnswerState()
        }
    }

    private func resetAnswerState() {
        selectedAnswerIndex = nil
        selectedAnswerIsCorrect = nil
        isAnswerSelected = false
    }

    func restartQuiz() {
        stopTimer()
        currentQuestionIndex = 0
        allCorrect = true
        gameOver = false
        resetAnswerState()
        startTimer()
    }
}
