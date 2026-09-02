import Foundation
import Testing
@testable import Pandita

/// Guards the bundled text against a bad regeneration of `content.json`.
@Suite("Bundled content")
struct ContentDecodingTests {
    /// `LibraryStore` lives in the app module, so this resolves the host app
    /// bundle rather than the test bundle, which `content.json` is not copied into.
    private var appBundle: Bundle { Bundle(for: LibraryStore.self) }

    private func loadBundledLibrary() async throws -> Library {
        try await BundleContentRepository(bundle: appBundle).loadLibrary()
    }

    @Test("The bundled text decodes with every chapter and verse present")
    func decodes() async throws {
        let library = try await loadBundledLibrary()

        #expect(library.chapters.count == 9)
        #expect(library.allVerses.count == 457)
    }

    @Test("Verse ids are unique and contiguous from 1")
    func verseIDsAreUniqueAndContiguous() async throws {
        let ids = try await loadBundledLibrary().allVerses.map(\.id)

        #expect(Set(ids).count == ids.count, "verse ids must be unique across the whole text")
        #expect(ids == Array(1...ids.count), "bookmarks assume ids run 1...n in reading order")
    }

    @Test("Each verse agrees with the chapter that contains it")
    func versesAgreeWithTheirChapter() async throws {
        for chapter in try await loadBundledLibrary().chapters {
            #expect(chapter.verses.allSatisfy { $0.chapter == chapter.id })
            #expect(chapter.verses.first?.id == chapter.verseRange.start)
            #expect(chapter.verses.last?.id == chapter.verseRange.end)
        }
    }

    @Test("No verse or chapter title is missing a language")
    func everyLanguageIsPresent() async throws {
        let library = try await loadBundledLibrary()

        for verse in library.allVerses {
            #expect(verse.allText.allSatisfy { !$0.isEmpty }, "verse \(verse.id) is missing a language")
        }
        for chapter in library.chapters {
            #expect(chapter.title.allText.allSatisfy { !$0.isEmpty }, "chapter \(chapter.id) is missing a title")
        }
    }

    @Test("A missing resource reports which file was missing")
    func missingResource() async {
        let repository = BundleContentRepository(resourceName: "does-not-exist", bundle: appBundle)
        await #expect(throws: ContentError.self) {
            try await repository.loadLibrary()
        }
    }
}
