#if DEBUG
import Foundation

extension Library {
    /// Fixture used by `#Preview` blocks and unit tests, so previews never depend on the bundle.
    static let preview = Library(
        title: "Pandita",
        chapters: [
            Chapter(
                id: "ch-01",
                number: 1,
                title: "The Wise",
                subtitle: "On recognising sound judgement",
                verses: [
                    Verse(id: "v-1-1", number: 1, text: "Placeholder verse one.", commentary: "Placeholder commentary."),
                    Verse(id: "v-1-2", number: 2, text: "Placeholder verse two."),
                    Verse(id: "v-1-3", number: 3, text: "Placeholder verse three.")
                ]
            ),
            Chapter(
                id: "ch-02",
                number: 2,
                title: "The Noble",
                subtitle: "On conduct that holds up under pressure",
                verses: [
                    Verse(id: "v-2-1", number: 1, text: "Placeholder verse four."),
                    Verse(id: "v-2-2", number: 2, text: "Placeholder verse five.", commentary: "Placeholder commentary.")
                ]
            )
        ]
    )
}

extension SavedStore {
    /// A store backed by a throwaway defaults suite, so previews never touch real bookmarks.
    static func preview(saving verseIDs: [Verse.ID] = []) -> SavedStore {
        let suiteName = "preview.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName) ?? .standard
        let store = SavedStore(defaults: defaults)
        for id in verseIDs.reversed() { store.toggle(id) }
        return store
    }
}
#endif
