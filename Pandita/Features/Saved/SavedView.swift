import SwiftUI

/// Bookmarked verses, newest first.
struct SavedView: View {
    @Environment(LibraryStore.self) private var library
    @Environment(SavedStore.self) private var saved

    private var verses: [Verse] {
        saved.savedVerses(in: library.library)
    }

    var body: some View {
        NavigationStack {
            Group {
                if verses.isEmpty {
                    ContentUnavailableView(
                        "Nothing saved yet",
                        systemImage: "bookmark",
                        description: Text("Tap the bookmark on any verse to keep it here.")
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: Theme.Metrics.stackSpacing) {
                            ForEach(verses) { verse in
                                VerseCard(verse: verse, showsChapterCaption: caption(for: verse))
                                    .contextMenu {
                                        Button("Remove", systemImage: "bookmark.slash", role: .destructive) {
                                            withAnimation { saved.remove(verse.id) }
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 32)
                    }
                    .scrollEdgeEffectStyle(.soft, for: .top)
                }
            }
            .navigationTitle(AppTab.saved.title)
            .toolbar {
                if !verses.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Remove All", systemImage: "trash", role: .destructive) {
                            withAnimation { saved.removeAll() }
                        }
                        .labelStyle(.iconOnly)
                    }
                }
            }
        }
    }

    private func caption(for verse: Verse) -> String? {
        guard let chapter = library.library.chapter(containing: verse.id) else { return nil }
        return "Ch. \(chapter.number) · Verse \(verse.number)"
    }
}

#Preview("With saves") {
    SavedView()
        .environment(LibraryStore.preview())
        .environment(SavedStore.preview(saving: ["v-1-1", "v-2-2"]))
        .tint(Theme.crimson)
}

#Preview("Empty") {
    SavedView()
        .environment(LibraryStore.preview())
        .environment(SavedStore.preview())
        .tint(Theme.crimson)
}
