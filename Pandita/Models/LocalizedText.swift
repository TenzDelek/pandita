import Foundation

/// A string carried in all three languages of the text.
struct LocalizedText: Hashable, Codable, Sendable {
    let tibetan: String
    let english: String
    let chinese: String

    func text(in language: ReadingLanguage) -> String {
        switch language {
        case .tibetan: tibetan
        case .english: english
        case .chinese: chinese
        }
    }

    /// Every language, for search.
    var allText: [String] { [tibetan, english, chinese] }
}
