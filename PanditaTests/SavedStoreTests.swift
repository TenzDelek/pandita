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

        store.toggle(1)
        store.toggle(42)
        #expect(store.savedVerseIDs == [42, 1])

        store.toggle(42)
        #expect(store.savedVerseIDs == [1])
        #expect(store.isSaved(42) == false)
    }

    @Test("Bookmarks survive a new store on the same defaults")
    func persists() {
        let (store, defaults, suite) = makeStore()
        defer { defaults.removePersistentDomain(forName: suite) }

        store.toggle(457)
        let reloaded = SavedStore(defaults: defaults)
        #expect(reloaded.savedVerseIDs == [457])
    }

    @Test("Resolving drops ids that are no longer in the text")
    func dropsUnknownIDs() {
        let (store, defaults, suite) = makeStore()
        defer { defaults.removePersistentDomain(forName: suite) }

        store.toggle(1)
        store.toggle(9_999) // removed in a later content revision

        #expect(store.savedVerses(in: .preview).map(\.id) == [1])
    }

    @Test("Bookmarks written in the old string format are discarded, not crashed on")
    func discardsLegacyStringIDs() {
        let (_, defaults, suite) = makeStore()
        defer { defaults.removePersistentDomain(forName: suite) }

        defaults.set(["v-1-2", "v-2-1"], forKey: "saved.verseIDs")

        let store = SavedStore(defaults: defaults)
        #expect(store.savedVerseIDs.isEmpty)
        #expect(defaults.array(forKey: "saved.verseIDs") == nil, "the dead key should not survive")
    }

    @Test("Removing everything clears storage")
    func removeAll() {
        let (store, defaults, suite) = makeStore()
        defer { defaults.removePersistentDomain(forName: suite) }

        store.toggle(1)
        store.toggle(2)
        store.removeAll()

        #expect(store.isEmpty)
        #expect(SavedStore(defaults: defaults).savedVerseIDs.isEmpty)
    }
}
