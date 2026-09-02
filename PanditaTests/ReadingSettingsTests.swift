import Foundation
import Testing
@testable import Pandita

@MainActor
@Suite("Reading settings")
struct ReadingSettingsTests {
    private func makeDefaults() -> (UserDefaults, String) {
        let suite = "tests.\(UUID().uuidString)"
        return (UserDefaults(suiteName: suite)!, suite)
    }

    @Test("Defaults to English against the root Tibetan")
    func defaultPair() {
        let (defaults, suite) = makeDefaults()
        defer { defaults.removePersistentDomain(forName: suite) }

        let settings = ReadingSettings(defaults: defaults)
        #expect(settings.primary == .english)
        #expect(settings.secondary == .tibetan)
    }

    @Test("Choosing the secondary language as primary clears the secondary")
    func primaryNeverDuplicatesSecondary() {
        let (defaults, suite) = makeDefaults()
        defer { defaults.removePersistentDomain(forName: suite) }

        let settings = ReadingSettings(defaults: defaults)
        settings.primary = .tibetan

        #expect(settings.secondary == nil, "a language cannot sit alongside itself")

        // And it must not spring back when the primary changes away again.
        settings.primary = .english
        #expect(settings.secondary == nil)
    }

    @Test("A secondary language is never offered as its own alternative")
    func secondaryOptionsExcludePrimary() {
        let (defaults, suite) = makeDefaults()
        defer { defaults.removePersistentDomain(forName: suite) }

        let settings = ReadingSettings(defaults: defaults)
        settings.primary = .chinese
        #expect(settings.secondaryOptions.contains(.chinese) == false)
        #expect(settings.secondaryOptions.count == 2)
    }

    @Test("Choices survive a relaunch, including turning the secondary off")
    func persists() {
        let (defaults, suite) = makeDefaults()
        defer { defaults.removePersistentDomain(forName: suite) }

        let settings = ReadingSettings(defaults: defaults)
        settings.primary = .chinese
        settings.secondary = nil

        let reloaded = ReadingSettings(defaults: defaults)
        #expect(reloaded.primary == .chinese)
        #expect(reloaded.secondary == nil, "an explicit 'None' must not fall back to the default")
    }

    @Test("An incoherent stored pair is repaired on load")
    func repairsStoredDuplicate() {
        let (defaults, suite) = makeDefaults()
        defer { defaults.removePersistentDomain(forName: suite) }

        defaults.set(true, forKey: "reading.hasChosen")
        defaults.set("tibetan", forKey: "reading.primaryLanguage")
        defaults.set("tibetan", forKey: "reading.secondaryLanguage")

        #expect(ReadingSettings(defaults: defaults).secondary == nil)
    }
}
