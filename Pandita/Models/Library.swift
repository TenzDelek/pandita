import Foundation

/// The whole text: the root object of `content.json`.
///
/// The shape mirrors the source file exactly, so the file can be regenerated
/// and dropped in without a transform step.
struct Library: Hashable, Codable, Sendable {
    let chapters: [Chapter]
}

extension Library {
    static let empty = Library(chapters: [])

    var isEmpty: Bool { chapters.isEmpty }

    /// Every verse in reading order, flattened across chapters.
    var allVerses: [Verse] {
        chapters.flatMap(\.verses)
    }

    func verse(id: Verse.ID) -> Verse? {
        // Verse ids are globally unique, so the first hit is the only hit.
        for chapter in chapters {
            if let match = chapter.verses.first(where: { $0.id == id }) { return match }
        }
        return nil
    }

    /// Verses matching `term` in any of the three languages.
    func search(_ term: String, limit: Int = 100) -> [Verse] {
        let term = term.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !term.isEmpty else { return [] }
        var results: [Verse] = []
        for verse in allVerses where verse.allText.contains(where: { $0.localizedStandardContains(term) }) {
            results.append(verse)
            if results.count == limit { break }
        }
        return results
    }
}
