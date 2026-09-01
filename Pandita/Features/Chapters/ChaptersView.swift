import SwiftUI

/// The table of contents.
struct ChaptersView: View {
    @Environment(LibraryStore.self) private var library
    @State private var query = ""

    private var chapters: [Chapter] {
        let all = library.library.chapters
        let term = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !term.isEmpty else { return all }
        return all.filter { chapter in
            chapter.title.localizedStandardContains(term)
                || (chapter.subtitle?.localizedStandardContains(term) ?? false)
                || chapter.verses.contains { $0.text.localizedStandardContains(term) }
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(chapters) { chapter in
                    NavigationLink(value: chapter) {
                        ChapterRow(chapter: chapter)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(AppTab.chapters.title)
            .navigationDestination(for: Chapter.self) { ChapterDetailView(chapter: $0) }
            .searchable(text: $query, prompt: "Search chapters and verses")
            .overlay {
                if chapters.isEmpty {
                    emptyState
                }
            }
        }
    }

    @ViewBuilder
    private var emptyState: some View {
        if library.isLoading {
            ProgressView().controlSize(.large)
        } else if !query.isEmpty {
            ContentUnavailableView.search(text: query)
        } else {
            ContentUnavailableView(
                "No chapters yet",
                systemImage: "book.closed",
                description: Text("Add chapters to content.json to fill the library.")
            )
        }
    }
}

private struct ChapterRow: View {
    let chapter: Chapter

    var body: some View {
        HStack(spacing: 14) {
            Text("\(chapter.number)")
                .font(.headline.monospacedDigit())
                .foregroundStyle(Theme.crimson)
                .frame(width: 32, alignment: .center)

            VStack(alignment: .leading, spacing: 3) {
                Text(chapter.title)
                    .font(.headline)
                if let subtitle = chapter.subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Text("^[\(chapter.verses.count) verse](inflect: true)")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ChaptersView()
        .environment(LibraryStore.preview())
        .environment(SavedStore.preview())
        .tint(Theme.crimson)
}
