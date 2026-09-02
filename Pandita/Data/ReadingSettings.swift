import Foundation
import Observation

/// Which language the reader is in, and whether a second one is shown alongside it.
///
/// A parallel reading — root Tibetan against a translation — is the normal way
/// this text is studied, so the secondary language is a first-class setting
/// rather than a toggle buried in the verse view.
@MainActor
@Observable
final class ReadingSettings {
    private enum Key {
        static let primary = "reading.primaryLanguage"
        static let secondary = "reading.secondaryLanguage"
        /// Written whenever the reader has made a choice, so a stored "no
        /// secondary language" is distinguishable from never having chosen.
        static let hasChosen = "reading.hasChosen"
    }

    var primary: ReadingLanguage {
        didSet {
            // A secondary equal to the primary is not a parallel reading. Clear
            // it rather than hiding it at render time, or it springs back the
            // moment the primary changes away again.
            if secondary == primary { secondary = nil }
            persist()
        }
    }

    /// `nil` shows a single language. Never equal to `primary`.
    var secondary: ReadingLanguage? {
        didSet { persist() }
    }

    @ObservationIgnored private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        if defaults.bool(forKey: Key.hasChosen) {
            self.primary = defaults.string(forKey: Key.primary)
                .flatMap(ReadingLanguage.init(rawValue:)) ?? .english
            let stored = defaults.string(forKey: Key.secondary)
                .flatMap(ReadingLanguage.init(rawValue:))
            self.secondary = stored == self.primary ? nil : stored
        } else {
            // Default to the root text under a translation the reader can follow.
            self.primary = .english
            self.secondary = .tibetan
        }
    }

    /// Languages offered as a secondary, excluding whatever is already primary.
    var secondaryOptions: [ReadingLanguage] {
        ReadingLanguage.allCases.filter { $0 != primary }
    }

    private func persist() {
        defaults.set(true, forKey: Key.hasChosen)
        defaults.set(primary.rawValue, forKey: Key.primary)
        if let secondary {
            defaults.set(secondary.rawValue, forKey: Key.secondary)
        } else {
            defaults.removeObject(forKey: Key.secondary)
        }
    }
}
