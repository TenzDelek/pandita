import Foundation

/// The span of global verse numbers a chapter covers.
struct VerseRange: Hashable, Codable, Sendable {
    let start: Int
    let end: Int

    var formatted: String { "\(start)–\(end)" }
}

/// A chapter groups a contiguous run of verses.
struct Chapter: Identifiable, Hashable, Codable, Sendable {
    /// Chapter number, 1...9.
    let id: Int
    let title: LocalizedText
    let verseRange: VerseRange
    let verses: [Verse]
}
