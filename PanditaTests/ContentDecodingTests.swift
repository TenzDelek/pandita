import Foundation
import Testing
@testable import Pandita

@Suite("Bundled content")
struct ContentDecodingTests {
    /// `LibraryStore` lives in the app module, so this resolves the host app bundle
    /// rather than the test bundle that `content.json` is not copied into.
    private var appBundle: Bundle { Bundle(for: LibraryStore.self) }

    @Test("content.json decodes and every verse id is unique")
    func bundledContentDecodes() async throws {
        let repository = BundleContentRepository(bundle: appBundle)
        let library = try await repository.loadLibrary()

        #expect(library.version == 1)
        #expect(!library.chapters.isEmpty)

        let ids = library.allVerses.map(\.id)
        #expect(Set(ids).count == ids.count, "verse ids must be unique across the whole library")
    }

    @Test("A missing resource reports which file was missing")
    func missingResource() async {
        let repository = BundleContentRepository(resourceName: "does-not-exist", bundle: appBundle)
        await #expect(throws: ContentError.self) {
            try await repository.loadLibrary()
        }
    }
}
