import SwiftUI

/// One verse a day, plus a way into the chapter it came from.
struct TodayView: View {
    @Environment(LibraryStore.self) private var library
    @Environment(SavedStore.self) private var saved

    @Namespace private var glassNamespace
    @State private var now = Date.now

    private var verse: Verse? {
        DailyVerse.verse(for: now, in: library.library)
    }

    private var chapter: Chapter? {
        verse.flatMap { library.library.chapter(containing: $0.id) }
    }

    var body: some View {
        NavigationStack {
            Group {
                switch library.phase {
                case .idle, .loading:
                    ProgressView().controlSize(.large)
                case .failed(let message):
                    ContentUnavailableView {
                        Label("Can't load the text", systemImage: "exclamationmark.triangle")
                    } description: {
                        Text(message)
                    } actions: {
                        Button("Try Again") { Task { await library.load() } }
                            .buttonStyle(.glassProminent)
                    }
                case .loaded:
                    content
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle(AppTab.today.title)
            .navigationBarTitleDisplayMode(.large)
        }
    }

    @ViewBuilder
    private var content: some View {
        if let verse {
            ScrollView {
                VStack(spacing: Theme.Metrics.stackSpacing) {
                    hero(for: verse)
                    if let chapter {
                        chapterLink(chapter)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
            // Softens content as it passes under the navigation bar's glass.
            .scrollEdgeEffectStyle(.soft, for: .top)
        } else {
            ContentUnavailableView(
                "No verses yet",
                systemImage: "text.book.closed",
                description: Text("Add verses to content.json to see a verse of the day.")
            )
        }
    }

    private func hero(for verse: Verse) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            GlassEffectContainer(spacing: 14) {
                VStack(alignment: .leading, spacing: 18) {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 14) {
                            Text(now, format: .dateTime.weekday(.wide).month(.wide).day())
                                .font(.footnote.weight(.semibold))
                                .textCase(.uppercase)
                                .foregroundStyle(.secondary)

                            Text(verse.text)
                                .font(.verseBody())
                                .lineSpacing(6)
                                .foregroundStyle(.primary)

                            if let commentary = verse.commentary {
                                Text(commentary)
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .glassEffectID("verse", in: glassNamespace)

                    HStack(spacing: 12) {
                        SaveButton(verseID: verse.id, showsLabel: true)
                            .buttonStyle(.glass)
                            .glassEffectID("save", in: glassNamespace)

                        ShareLink(item: verse.text) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                        .buttonStyle(.glass)
                        .glassEffectID("share", in: glassNamespace)
                    }
                }
            }
            .padding(.vertical, 24)
        }
        .frame(maxWidth: .infinity)
        .background {
            Theme.heroGradient
                .clipShape(.rect(cornerRadius: 32))
        }
    }

    private func chapterLink(_ chapter: Chapter) -> some View {
        NavigationLink(value: chapter) {
            GlassCard(isInteractive: true) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("From Chapter \(chapter.number)")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                        Text(chapter.title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.footnote.weight(.bold))
                        .foregroundStyle(.tertiary)
                }
            }
        }
        .buttonStyle(.plain)
        .navigationDestination(for: Chapter.self) { ChapterDetailView(chapter: $0) }
    }
}

#Preview {
    TodayView()
        .environment(LibraryStore.preview())
        .environment(SavedStore.preview())
        .tint(Theme.crimson)
}
