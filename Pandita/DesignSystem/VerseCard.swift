import SwiftUI

/// A verse on glass, in the current reading language, with its bookmark control.
struct VerseCard: View {
    let verse: Verse
    /// Overrides the default "Verse N" caption, e.g. to name the chapter too.
    var caption: String?

    @Environment(ReadingSettings.self) private var settings

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .firstTextBaseline) {
                    Text(caption ?? "Verse \(verse.id)")
                        .font(.caption.weight(.semibold))
                        .textCase(.uppercase)
                        .foregroundStyle(.secondary)
                    Spacer()
                    SaveButton(verseID: verse.id)
                        .buttonStyle(.borderless)
                        .foregroundStyle(Theme.crimson)
                }

                VerseText(text: verse.text(in: settings.primary), language: settings.primary)

                if let secondary = settings.secondary {
                    Divider().opacity(0.4)
                    VerseText(
                        text: verse.text(in: secondary),
                        language: secondary,
                        isSecondary: true
                    )
                }
            }
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 16) {
            ForEach(Library.preview.chapters[0].verses) { VerseCard(verse: $0) }
        }
        .padding()
    }
    .environment(SavedStore.preview(saving: [1]))
    .environment(ReadingSettings.preview())
}
