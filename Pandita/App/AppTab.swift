import Foundation

/// The app's top-level destinations.
enum AppTab: String, CaseIterable, Identifiable, Hashable {
    case today
    case chapters
    case saved

    var id: Self { self }

    var title: String {
        switch self {
        case .today: "Today"
        case .chapters: "Chapters"
        case .saved: "Saved"
        }
    }

    var symbol: String {
        switch self {
        case .today: "sun.horizon"
        case .chapters: "book.closed"
        case .saved: "bookmark"
        }
    }
}
