import Foundation
import Testing
@testable import Pandita

@Suite("Daily artwork")
struct HeroArtworkTests {
    private var utc: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }

    @Test("The same day always yields the same artwork")
    func isStableWithinADay() {
        let morning = Date(timeIntervalSince1970: 1_699_920_000)
        let evening = morning.addingTimeInterval(60 * 60 * 8)

        #expect(HeroArtwork.artwork(for: morning, calendar: utc)
            == HeroArtwork.artwork(for: evening, calendar: utc))
    }

    @Test("Consecutive days show different artwork")
    func changesDaily() {
        let day = Date(timeIntervalSince1970: 1_699_920_000)
        let next = day.addingTimeInterval(60 * 60 * 24)

        #expect(HeroArtwork.artwork(for: day, calendar: utc)
            != HeroArtwork.artwork(for: next, calendar: utc))
    }

    @Test("Every case cycles through over a full rotation")
    func coversEveryCase() {
        let start = Date(timeIntervalSince1970: 1_699_920_000)
        let seen = (0..<HeroArtwork.allCases.count).map {
            HeroArtwork.artwork(for: start.addingTimeInterval(Double($0) * 86_400), calendar: utc)
        }
        #expect(Set(seen).count == HeroArtwork.allCases.count)
    }
}
