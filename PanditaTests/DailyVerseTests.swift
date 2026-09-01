import Foundation
import Testing
@testable import Pandita

@Suite("Verse of the day")
struct DailyVerseTests {
    private var utc: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }

    @Test("The same day always yields the same verse")
    func isStableWithinADay() {
        // A UTC midnight, so the +8h offset stays inside the same calendar day.
        let morning = Date(timeIntervalSince1970: 1_699_920_000)
        let evening = morning.addingTimeInterval(60 * 60 * 8)
        let library = Library.preview

        #expect(DailyVerse.verse(for: morning, in: library, calendar: utc)
            == DailyVerse.verse(for: evening, in: library, calendar: utc))
    }

    @Test("Consecutive days advance by one verse")
    func advancesDaily() {
        let day = Date(timeIntervalSince1970: 1_699_920_000)
        let next = day.addingTimeInterval(60 * 60 * 24)
        let count = Library.preview.allVerses.count

        let first = DailyVerse.index(for: day, count: count, calendar: utc)
        let second = DailyVerse.index(for: next, count: count, calendar: utc)

        #expect(second == (first + 1) % count)
    }

    @Test("Dates before the epoch still index in range")
    func handlesPreEpochDates() {
        let date = Date(timeIntervalSince1970: -60 * 60 * 24 * 400)
        let index = DailyVerse.index(for: date, count: 5, calendar: utc)
        #expect((0..<5).contains(index))
    }

    @Test("An empty library has no verse of the day")
    func emptyLibrary() {
        #expect(DailyVerse.verse(for: .now, in: .empty, calendar: utc) == nil)
    }
}
