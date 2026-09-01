import Foundation

/// A chapter groups an ordered run of verses.
struct Chapter: Identifiable, Hashable, Codable, Sendable {
    let id: String
    /// Position of the chapter within the library, 1-based.
    let number: Int
    let title: String
    /// Short line shown under the title in the chapter list.
    let subtitle: String?
    let verses: [Verse]

    init(id: String, number: Int, title: String, subtitle: String? = nil, verses: [Verse]) {
        self.id = id
        self.number = number
        self.title = title
        self.subtitle = subtitle
        self.verses = verses
    }
}
