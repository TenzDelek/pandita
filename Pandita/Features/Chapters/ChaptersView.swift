import SwiftUI

/// The table of contents, and search across all three languages.
struct ChaptersView: View {
    @Environment(LibraryStore.self) private var library
    @Environment(ReadingSettings.self) private var settings

    @State private var query = ""

    private var trimmedQuery: String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var isSearching: Bool { !trimmedQuery.isEmpty }

    /// With 457 verses, matching whole chapters is close to useless — searching
    /// returns the verses themselves.
    private var results: [Verse] {
        library.library.search(trimmedQuery)
    }

    var body: some View {
        NavigationStack {
            Group {
                if isSearching {
                    searchResults
                } else {
                    chapterList
                }
            }
            .navigationTitle(AppTab.chapters.title)
            .navigationDestination(for: Chapter.self) { ChapterDetailView(chapter: $0) }
            .searchable(text: $query, prompt: "Search all languages")
            .toolbar { ToolbarItem(placement: .topBarTrailing) { LanguageMenu() } }
        }
    }

    private var chapterList: some View {
        List {
            ForEach(library.library.chapters) { chapter in
                NavigationLink(value: chapter) {
                    ChapterRow(chapter: chapter, language: settings.primary)
                }
            }
        }
        .listStyle(.insetGrouped)
        .overlay {
            if library.library.isEmpty {
                if library.isLoading {
                    ProgressView().controlSize(.large)
                } else {
                    ContentUnavailableView(
                        "No chapters",
                        systemImage: "book.closed",
                        description: Text("content.json has no chapters in it.")
                    )
                }
            }
        }
    }

    @ViewBuilder
    private var searchResults: some View {
        if results.isEmpty {
            ContentUnavailableView.search(text: trimmedQuery)
        } else {
            ScrollView {
                LazyVStack(spacing: Theme.Metrics.stackSpacing) {
                    ForEach(results) { verse in
                        VerseCard(verse: verse, caption: "Ch. \(verse.chapter) · Verse \(verse.id)")
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
            .scrollEdgeEffectStyle(.soft, for: .top)
        }
    }
}

private struct ChapterRow: View {
    let chapter: Chapter
    let language: ReadingLanguage

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // The title names its own chapter number in every language, so no
            // separate number badge here.
            Text(chapter.title.text(in: language))
                .font(language == .tibetan ? language.verseFont(size: 17) : .headline)
                .lineSpacing(language == .tibetan ? 8 : 0)
                .foregroundStyle(.primary)

            Text("Verses \(chapter.verseRange.formatted) · ^[\(chapter.verses.count) verse](inflect: true)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ChaptersView()
        .environment(LibraryStore.preview())
        .environment(SavedStore.preview())
        .environment(ReadingSettings.preview())
        .tint(Theme.crimson)
}
