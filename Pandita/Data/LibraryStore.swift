import Foundation
import Observation

/// Owns the loaded text and its load state. One instance lives for the life of the app.
@MainActor
@Observable
final class LibraryStore {
    enum Phase {
        case idle
        case loading
        case loaded(Library)
        case failed(String)
    }

    private(set) var phase: Phase = .idle

    private let repository: any ContentRepository

    init(repository: any ContentRepository = BundleContentRepository()) {
        self.repository = repository
    }

    /// The loaded text, or an empty library while loading or after a failure.
    var library: Library {
        if case .loaded(let library) = phase { return library }
        return .empty
    }

    var isLoading: Bool {
        if case .loading = phase { return true }
        return false
    }

    /// Loads the text once. Safe to call from `.task` on every appearance.
    func loadIfNeeded() async {
        guard case .idle = phase else { return }
        await load()
    }

    func load() async {
        phase = .loading
        do {
            phase = .loaded(try await repository.loadLibrary())
        } catch {
            phase = .failed(error.localizedDescription)
        }
    }
}

extension LibraryStore {
    /// A store already populated with sample content, for `#Preview` blocks.
    static func preview(_ library: Library = .preview) -> LibraryStore {
        let store = LibraryStore(repository: StaticContentRepository(library: library))
        store.phase = .loaded(library)
        return store
    }
}
