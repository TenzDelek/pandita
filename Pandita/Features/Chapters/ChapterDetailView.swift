import SwiftUI

/// The reading screen: every verse in a chapter.
struct ChapterDetailView: View {
    let chapter: Chapter

    @Environment(ReadingSettings.self) private var settings

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: Theme.Metrics.stackSpacing) {
                header
                ForEach(chapter.verses) { verse in
                    VerseCard(verse: verse)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
        .scrollEdgeEffectStyle(.soft, for: .top)
        .navigationTitle("Chapter \(chapter.id)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .topBarTrailing) { LanguageMenu() } }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(chapter.title.text(in: settings.primary))
                .font(settings.primary == .tibetan ? settings.primary.verseFont(size: 20) : .title3.weight(.semibold))
                .lineSpacing(settings.primary == .tibetan ? 10 : 0)

            Text("Verses \(chapter.verseRange.formatted)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 4)
        .padding(.bottom, 4)
    }
}

#Preview {
    NavigationStack {
        ChapterDetailView(chapter: Library.preview.chapters[0])
    }
    .environment(SavedStore.preview(saving: [2]))
    .environment(ReadingSettings.preview())
    .tint(Theme.crimson)
}
