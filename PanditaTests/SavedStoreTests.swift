import Foundation
import Testing
@testable import Pandita

@MainActor
@Suite("Bookmarks")
struct SavedStoreTests {
    private func makeStore() -> (SavedStore, UserDefaults, String) {
        let suite = "tests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        return (SavedStore(defaults: defaults), defaults, suite)
    }

    @Test("Toggling adds then removes, newest first")
    func toggleOrdering() {
        let (store, defaults, suite) = makeStore()
        defer { defaults.removePersistentDomain(forName: suite) }

        store.toggle("v-1-1")
        store.toggle("v-2-2")
        #expect(store.savedVerseIDs == ["v-2-2", "v-1-1"])

        store.toggle("v-2-2")
        #expect(store.savedVerseIDs == ["v-1-1"])
        #expect(store.isSaved("v-2-2") == false)
    }

    @Test("Bookmarks survive a new store on the same defaults")
    func persists() {
        let (store, defaults, suite) = makeStore()
        defer { defaults.removePersistentDomain(forName: suite) }

        store.toggle("v-1-3")
        let reloaded = SavedStore(defaults: defaults)
        #expect(reloaded.savedVerseIDs == ["v-1-3"])
    }

    @Test("Resolving drops ids that are no longer in the text")
    func dropsUnknownIDs() {
        let (store, defaults, suite) = makeStore()
        defer { defaults.removePersistentDomain(forName: suite) }

        store.toggle("v-1-1")
        store.toggle("removed-in-a-later-revision")

        let verses = store.savedVerses(in: .preview)
        #expect(verses.map(\.id) == ["v-1-1"])
    }
}
