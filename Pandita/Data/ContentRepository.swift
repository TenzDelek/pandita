import Foundation

/// Source of the app's text.
///
/// The app ships with a JSON file today; this protocol is the seam that lets that
/// become a downloaded or generated payload later without touching the feature code.
protocol ContentRepository: Sendable {
    func loadLibrary() async throws -> Library
}

enum ContentError: LocalizedError {
    case resourceMissing(name: String)
    case decodingFailed(underlying: any Error)

    var errorDescription: String? {
        switch self {
        case .resourceMissing(let name):
            "Couldn't find \(name) in the app bundle."
        case .decodingFailed:
            "The text file is in an unexpected format."
        }
    }

    var failureReason: String? {
        switch self {
        case .resourceMissing:
            nil
        case .decodingFailed(let underlying):
            String(describing: underlying)
        }
    }
}
