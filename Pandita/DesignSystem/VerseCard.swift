import SwiftUI

/// A verse rendered on glass, with its bookmark control.
struct VerseCard: View {
    let verse: Verse
    var showsChapterCaption: String?

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .firstTextBaseline) {
                    Text(showsChapterCaption ?? "Verse \(verse.number)")
                        .font(.caption.weight(.semibold))
                        .textCase(.uppercase)
                        .foregroundStyle(.secondary)
                    Spacer()
                    SaveButton(verseID: verse.id)
                        .buttonStyle(.borderless)
                        .foregroundStyle(Theme.crimson)
                }

                Text(verse.text)
                    .font(.verseBody(19))
                    .lineSpacing(5)

                if let commentary = verse.commentary {
                    Text(commentary)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
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
    .environment(SavedStore.preview(saving: ["v-1-1"]))
}
