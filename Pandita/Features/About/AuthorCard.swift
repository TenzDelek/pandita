import SwiftUI

/// Tappable row on Today that opens the author drawer.
struct AuthorCard: View {
    let author: Author
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            GlassCard(isInteractive: true) {
                HStack(spacing: 14) {
                    Image(author.portraitAsset)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        // The thangka puts his face in the upper band, so a
                        // top-anchored square crop keeps it in the thumbnail.
                        .frame(width: 52, height: 52, alignment: .top)
                        .clipShape(.rect(cornerRadius: 12))
                        .accessibilityHidden(true)

                    VStack(alignment: .leading, spacing: 3) {
                        Text("About the author")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                        Text(author.name)
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)
                    }

                    Spacer(minLength: 8)

                    Image(systemName: "chevron.right")
                        .font(.footnote.weight(.bold))
                        .foregroundStyle(.tertiary)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("About \(author.name)")
        .accessibilityHint("Opens a biography")
    }
}

#Preview {
    AuthorCard(author: .sakyaPandita) {}
        .padding()
}
