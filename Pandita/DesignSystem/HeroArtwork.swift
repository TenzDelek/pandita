import SwiftUI

/// The illustrations behind the verse of the day.
///
/// Rotated by calendar day, the same way the verse is, so Today looks different
/// each morning without anything being stored. The art carries no meaning tied
/// to a particular verse — nothing in the text maps onto it — so the pairing is
/// deliberately just a rotation.
enum HeroArtwork: String, CaseIterable, Identifiable, Sendable {
    case peace = "Peace"
    case hope = "Hope"
    case meditation = "Meditation"
    case aspiration = "Aspiration"
    case healing = "Healing"
    case prayerFlags = "PrayerFlags"
    case dawn = "Dawn"

    var id: Self { self }

    var image: Image { Image(rawValue) }

    /// The tone the artwork fades into behind the verse, drawn from the dark end
    /// of each illustration's own palette so the fade reads as part of the image
    /// rather than a grey wash laid over it.
    var fadeColor: Color {
        switch self {
        case .peace: Color(red: 0.09, green: 0.20, blue: 0.07)
        case .hope: Color(red: 0.04, green: 0.24, blue: 0.30)
        case .meditation: Color(red: 0.27, green: 0.10, blue: 0.07)
        case .aspiration: Color(red: 0.07, green: 0.13, blue: 0.38)
        case .healing: Color(red: 0.16, green: 0.24, blue: 0.05)
        case .prayerFlags: Color(red: 0.05, green: 0.16, blue: 0.29)
        case .dawn: Color(red: 0.12, green: 0.22, blue: 0.10)
        }
    }

    static func artwork(for date: Date, calendar: Calendar = .current) -> HeroArtwork {
        let all = allCases
        return all[DailyVerse.index(for: date, count: all.count, calendar: calendar)]
    }
}
