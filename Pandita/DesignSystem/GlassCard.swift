import SwiftUI

/// A content card floated on Liquid Glass.
///
/// Use this for custom surfaces only. System containers — lists, bars, sheets —
/// already get glass from the SDK and should not be wrapped in it again.
struct GlassCard<Content: View>: View {
    var tint: Color?
    var isInteractive: Bool = false
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(Theme.Metrics.cardPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassEffect(glass, in: .rect(cornerRadius: Theme.Metrics.cardCorner))
    }

    private var glass: Glass {
        var glass = Glass.regular
        if let tint { glass = glass.tint(tint) }
        if isInteractive { glass = glass.interactive() }
        return glass
    }
}

#Preview {
    ZStack {
        Theme.heroGradient.ignoresSafeArea()
        GlassCard {
            VStack(alignment: .leading, spacing: 8) {
                Text("Verse 12").font(.caption.smallCaps()).foregroundStyle(.secondary)
                Text("Placeholder verse text sitting on Liquid Glass.").font(.verseBody())
            }
        }
        .padding()
    }
}
