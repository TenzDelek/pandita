import Foundation
import Observation

/// Bookmarked verses, newest first, persisted locally in `UserDefaults`.
///
/// There is no backend: this is the only writable state in the app.
@MainActor
@Observable
final class SavedStore {
    private static let storageKey = "saved.verseIDs"

    private(set) var savedVerseIDs: [Verse.ID] = []

    @ObservationIgnored private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.savedVerseIDs = defaults.stringArray(forKey: Self.storageKey) ?? []
    }

    func isSaved(_ verseID: Verse.ID) -> Bool {
        savedVerseIDs.contains(verseID)
    }

    func toggle(_ verseID: Verse.ID) {
        if isSaved(verseID) {
            savedVerseIDs.removeAll { $0 == verseID }
        } else {
            savedVerseIDs.insert(verseID, at: 0)
        }
        persist()
    }

    func remove(_ verseID: Verse.ID) {
        guard isSaved(verseID) else { return }
        savedVerseIDs.removeAll { $0 == verseID }
        persist()
    }

    func removeAll() {
        guard !savedVerseIDs.isEmpty else { return }
        savedVerseIDs.removeAll()
        persist()
    }

    /// Saved verses resolved against the current text, dropping IDs that no longer exist.
    func savedVerses(in library: Library) -> [Verse] {
        savedVerseIDs.compactMap { library.verse(id: $0) }
    }

    private func persist() {
        defaults.set(savedVerseIDs, forKey: Self.storageKey)
    }
}
