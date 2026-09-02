import SwiftUI

/// The languages the text is carried in. Every verse and chapter title exists
/// in all three, so a language is always resolvable — no fallbacks needed.
enum ReadingLanguage: String, CaseIterable, Identifiable, Codable, Sendable {
    case english
    case tibetan
    case chinese

    var id: Self { self }

    /// Endonym, so the picker reads correctly to a speaker of each language.
    var label: String {
        switch self {
        case .english: "English"
        case .tibetan: "བོད་ཡིག"
        case .chinese: "中文"
        }
    }

    var shortLabel: String {
        switch self {
        case .english: "EN"
        case .tibetan: "བོད"
        case .chinese: "中"
        }
    }

    /// Tibetan needs a taller line box than Latin or Han for its stacked glyphs
    /// and its descenders to survive; Han sits between the two.
    var verseLineSpacing: CGFloat {
        switch self {
        case .english: 6
        case .tibetan: 14
        case .chinese: 9
        }
    }

    func verseFont(size: CGFloat = 19) -> Font {
        switch self {
        case .english:
            .system(size: size, weight: .regular, design: .serif)
        case .tibetan:
            // Kailasa ships with iOS; Font.custom falls back to the system
            // Tibetan face if it is ever absent.
            .custom("Kailasa", size: size + 3, relativeTo: .body)
        case .chinese:
            .system(size: size + 1, weight: .regular)
        }
    }
}
