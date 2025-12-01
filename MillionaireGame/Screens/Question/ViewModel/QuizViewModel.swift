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
    
    @Published var currentScore: Int = 0
    @Published var bestScore: Int = UserDefaults.standard.integer(forKey: "BEST_SCORE")
    
    func fireConfetti() { confettiCounter += 1 }
    
    @Published var usedFiftyFifty = false
    @Published var usedAskAudience = false
    @Published var usedPhoneAFriend = false
    @Published var availableOptions: [Int] = []
    @Published var audienceVotes: [String: Int] = [:]
    @Published var phoneCallMessage: String = ""
    
    @Published var cashOutEarly = false

    
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
                self.allCorrect = false
                self.finishGame()
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
        
        if correct {
            let cleanPrize = currentQuestion.prize
                .replacingOccurrences(of: "$", with: "")
                .replacingOccurrences(of: ",", with: "")
                .trimmingCharacters(in: .whitespaces)
            
            currentScore = Int(cleanPrize) ?? 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.nextQuestion()
            }
            
        } else {
            allCorrect = false
            finishGame()
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
            finishGame()
            fireConfetti()
            resetAnswerState()
        }
    }
    
    func finishGame() {
        stopTimer()
        gameOver = true
        
        if currentScore > bestScore {
            bestScore = currentScore
            UserDefaults.standard.set(bestScore, forKey: "BEST_SCORE")
        }
    }
    
    private func resetAnswerState() {
        selectedAnswerIndex = nil
        selectedAnswerIsCorrect = nil
        isAnswerSelected = false
        
        availableOptions = Array(currentQuestion.options.indices)
        audienceVotes = [:]
        phoneCallMessage = ""
    }
    
    func restartQuiz() {
        stopTimer()
        currentQuestionIndex = 0
        allCorrect = true
        gameOver = false
        currentScore = 0
        resetAnswerState()
        
        usedFiftyFifty = false
        usedAskAudience = false
        usedPhoneAFriend = false
        
        startTimer()
    }
    
    func useFiftyFifty() {
        guard !usedFiftyFifty else { return }
        usedFiftyFifty = true
        
        let correctIndex = Int(currentQuestion.correct_answer) ?? 0
        let allIndexes = Array(currentQuestion.options.indices)
        
        let wrongIndexes = allIndexes.filter { $0 != correctIndex }
        let removedTwo = Array(wrongIndexes.shuffled().prefix(2))
        
        availableOptions = allIndexes.filter { !removedTwo.contains($0) }
    }
    
    func useAskAudience() {
        guard !usedAskAudience else { return }
        usedAskAudience = true
        
        let correctIndex = Int(currentQuestion.correct_answer) ?? 0
        let optionLetters = ["A", "B", "C", "D"]
        
        let available = usedFiftyFifty ? availableOptions : Array(currentQuestion.options.indices)
        
        var votes: [String: Int] = [:]
        
        let correctVote = Int.random(in: 55...75)
        votes[optionLetters[correctIndex]] = correctVote
        
        let remaining = 100 - correctVote
        let wrongOptions = available.filter { $0 != correctIndex }
        
        for idx in wrongOptions {
            votes[optionLetters[idx]] = remaining / wrongOptions.count
        }
        
        for i in 0..<4 {
            let letter = optionLetters[i]
            if votes[letter] == nil {
                votes[letter] = 0
            }
        }
        
        audienceVotes = votes
    }

    
    func usePhoneAFriend() {
        guard !usedPhoneAFriend else { return }
        usedPhoneAFriend = true
        
        let correctIndex = Int(currentQuestion.correct_answer) ?? 0
        let optionLetters = ["A", "B", "C", "D"]
        
        let isCorrect = Int.random(in: 1...100) <= 70
        
        let chosenIndex: Int
        if isCorrect {
            chosenIndex = correctIndex
        } else {
            chosenIndex = Array(currentQuestion.options.indices.filter { $0 != correctIndex }).randomElement() ?? correctIndex
        }
        
        let chosenLetter = optionLetters[chosenIndex]
        
        phoneCallMessage = [
            "Hmm… I think it's **\(chosenLetter)**.",
            "I'm not 100% sure, but I'd go with **\(chosenLetter)**.",
            "Maybe the answer is **\(chosenLetter)**, but I can't be sure.",
            "If I had to pick, I'd say **\(chosenLetter)**.",
        ].randomElement()!
    }
    
    func cashOut() {
        cashOutEarly = true
        stopTimer()
    }


}
