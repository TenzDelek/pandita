import SwiftUI

/// The reading screen: every verse in a chapter.
struct ChapterDetailView: View {
    let chapter: Chapter

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: Theme.Metrics.stackSpacing) {
                if let subtitle = chapter.subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 4)
                }

                ForEach(chapter.verses) { verse in
                    VerseCard(verse: verse)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
        .scrollEdgeEffectStyle(.soft, for: .top)
        .navigationTitle("Chapter \(chapter.number)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(chapter.title).font(.headline)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChapterDetailView(chapter: Library.preview.chapters[0])
    }
    .environment(SavedStore.preview(saving: ["v-1-2"]))
    .tint(Theme.crimson)
}
