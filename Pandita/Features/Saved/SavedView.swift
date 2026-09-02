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
                                VerseCard(verse: verse, caption: "Ch. \(verse.chapter) · Verse \(verse.id)")
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
            // Inline, so the title sits on the same row as the language control
            // rather than stacking below it.
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) { LanguageMenu() }
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
}

#Preview("With saves") {
    SavedView()
        .environment(LibraryStore.preview())
        .environment(SavedStore.preview(saving: [1, 4]))
        .environment(ReadingSettings.preview())
        .tint(Theme.crimson)
}

#Preview("Empty") {
    SavedView()
        .environment(LibraryStore.preview())
        .environment(SavedStore.preview())
        .environment(ReadingSettings.preview())
        .tint(Theme.crimson)
}
