import Foundation

struct Question: Identifiable, Codable {
    var id: String
    let question: String
    let options: [String]
    let correct_answer: String
    let prize: String
}
