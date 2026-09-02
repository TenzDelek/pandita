import Foundation
import Testing
@testable import Pandita

@Suite("Search")
struct SearchTests {
    @Test("Matches any of the three languages")
    func matchesEveryLanguage() {
        #expect(Library.preview.search("treasury").map(\.id) == [1])
        #expect(Library.preview.search("智者").isEmpty == false)
        #expect(Library.preview.search("མཁས་པ").isEmpty == false)
    }

    @Test("Matching ignores case and surrounding whitespace")
    func normalisesTheTerm() {
        #expect(Library.preview.search("  THE WISE  ").isEmpty == false)
    }

    @Test("An empty term matches nothing rather than everything")
    func emptyTerm() {
        #expect(Library.preview.search("").isEmpty)
        #expect(Library.preview.search("   ").isEmpty)
    }

    @Test("Results are capped")
    func respectsLimit() {
        // "" appears in no verse, but a single character does; cap it at two.
        #expect(Library.preview.search("e", limit: 2).count <= 2)
    }
}
