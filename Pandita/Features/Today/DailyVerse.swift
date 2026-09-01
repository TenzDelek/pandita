import Foundation

/// Picks the verse of the day.
///
/// Deterministic: the same calendar day always yields the same verse, so the
/// Today tab is stable across relaunches without persisting anything.
enum DailyVerse {
    static func verse(for date: Date, in library: Library, calendar: Calendar = .current) -> Verse? {
        let verses = library.allVerses
        guard !verses.isEmpty else { return nil }
        return verses[index(for: date, count: verses.count, calendar: calendar)]
    }

    static func index(for date: Date, count: Int, calendar: Calendar = .current) -> Int {
        precondition(count > 0, "count must be positive")
        let day = calendar.startOfDay(for: date)
        let daysSinceEpoch = calendar.dateComponents([.day], from: Date(timeIntervalSince1970: 0), to: day).day ?? 0
        // Swift's % keeps the sign of the dividend; dates before 1970 would otherwise index negatively.
        return ((daysSinceEpoch % count) + count) % count
    }
}
