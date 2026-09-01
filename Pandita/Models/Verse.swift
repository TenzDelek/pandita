import Foundation

/// A single verse of the text. Decoded straight from `content.json`.
struct Verse: Identifiable, Hashable, Codable, Sendable {
    /// Stable identifier used for bookmarks and deep links. Must not change between content revisions.
    let id: String
    /// Position of the verse within its chapter, 1-based.
    let number: Int
    /// The verse itself, in the reading language.
    let text: String
    /// Optional gloss or commentary shown beneath the verse.
    let commentary: String?

    init(id: String, number: Int, text: String, commentary: String? = nil) {
        self.id = id
        self.number = number
        self.text = text
        self.commentary = commentary
    }
}
