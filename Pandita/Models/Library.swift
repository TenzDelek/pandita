import Foundation

/// The whole bundled text: the root object of `content.json`.
struct Library: Hashable, Codable, Sendable {
    /// Schema version of the JSON payload, so a future format can be migrated rather than crash.
    let version: Int
    let title: String
    let chapters: [Chapter]

    init(version: Int = 1, title: String, chapters: [Chapter]) {
        self.version = version
        self.title = title
        self.chapters = chapters
    }
}

extension Library {
    static let empty = Library(title: "", chapters: [])

    /// Every verse in reading order, flattened across chapters.
    var allVerses: [Verse] {
        chapters.flatMap(\.verses)
    }

    func verse(id: Verse.ID) -> Verse? {
        for chapter in chapters {
            if let match = chapter.verses.first(where: { $0.id == id }) { return match }
        }
        return nil
    }

    func chapter(containing verseID: Verse.ID) -> Chapter? {
        chapters.first { chapter in
            chapter.verses.contains { $0.id == verseID }
        }
    }
}
