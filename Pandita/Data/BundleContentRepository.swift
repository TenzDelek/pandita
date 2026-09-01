import Foundation

/// Reads the text from a JSON file inside the app bundle.
struct BundleContentRepository: ContentRepository {
    private let resourceName: String
    private let resourceExtension: String
    private let bundle: Bundle

    init(resourceName: String = "content", resourceExtension: String = "json", bundle: Bundle = .main) {
        self.resourceName = resourceName
        self.resourceExtension = resourceExtension
        self.bundle = bundle
    }

    func loadLibrary() async throws -> Library {
        guard let url = bundle.url(forResource: resourceName, withExtension: resourceExtension) else {
            throw ContentError.resourceMissing(name: "\(resourceName).\(resourceExtension)")
        }
        let data = try Data(contentsOf: url, options: [.mappedIfSafe])
        do {
            return try JSONDecoder().decode(Library.self, from: data)
        } catch {
            throw ContentError.decodingFailed(underlying: error)
        }
    }
}

/// In-memory repository for previews and tests.
struct StaticContentRepository: ContentRepository {
    let library: Library
    var error: (any Error)?

    init(library: Library, error: (any Error)? = nil) {
        self.library = library
        self.error = error
    }

    func loadLibrary() async throws -> Library {
        if let error { throw error }
        return library
    }
}
