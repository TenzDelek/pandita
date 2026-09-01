import SwiftUI

/// Colours and metrics shared across the app, pulled from the app icon.
///
/// Everything else — bars, tab bar, sheets — is left to the system so it picks up
/// Liquid Glass automatically.
enum Theme {
    static let crimson = Color("BrandCrimson")
    static let gold = Color("BrandGold")
    static let sand = Color("BrandSand")

    enum Metrics {
        static let cardCorner: CGFloat = 26
        static let cardPadding: CGFloat = 20
        static let stackSpacing: CGFloat = 16
    }

    /// The warm wash behind the Today hero. Kept subtle so glass on top stays readable.
    static var heroGradient: LinearGradient {
        LinearGradient(
            colors: [gold.opacity(0.55), crimson.opacity(0.75), crimson.opacity(0.95)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

extension Font {
    /// Serif face for verse bodies; scales with Dynamic Type.
    static func verseBody(_ size: CGFloat = 21) -> Font {
        .system(size: size, weight: .regular, design: .serif)
    }

    static func verseTitle(_ size: CGFloat = 27) -> Font {
        .system(size: size, weight: .semibold, design: .serif)
    }
}
