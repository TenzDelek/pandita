import SwiftUI

/// One verse a day, plus a way into the chapter it came from.
struct TodayView: View {
    @Environment(LibraryStore.self) private var library
    @Environment(ReadingSettings.self) private var settings

    @Namespace private var glassNamespace
    @State private var now = Date.now

    private var verse: Verse? {
        DailyVerse.verse(for: now, in: library.library)
    }

    private var chapter: Chapter? {
        verse.flatMap { library.library.chapter(id: $0.chapter) }
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
            .toolbar { ToolbarItem(placement: .topBarTrailing) { LanguageMenu() } }
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
                "No verses",
                systemImage: "text.book.closed",
                description: Text("content.json has no verses in it.")
            )
        }
    }

    private func hero(for verse: Verse) -> some View {
        GlassEffectContainer(spacing: 14) {
            VStack(alignment: .leading, spacing: 18) {
                GlassCard {
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text(now, format: .dateTime.weekday(.wide).month(.wide).day())
                            Spacer()
                            Text("Verse \(verse.id)")
                        }
                        .font(.footnote.weight(.semibold))
                        .textCase(.uppercase)
                        .foregroundStyle(.secondary)

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
                .glassEffectID("verse", in: glassNamespace)

                HStack(spacing: 12) {
                    SaveButton(verseID: verse.id, showsLabel: true)
                        .buttonStyle(.glass)
                        .glassEffectID("save", in: glassNamespace)

                    ShareLink(item: shareText(for: verse)) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    .buttonStyle(.glass)
                    .glassEffectID("share", in: glassNamespace)
                }
            }
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background {
            Theme.heroGradient.clipShape(.rect(cornerRadius: 32))
        }
    }

    /// Shares whatever the reader is actually looking at, both languages included.
    private func shareText(for verse: Verse) -> String {
        var parts = [verse.text(in: settings.primary)]
        if let secondary = settings.secondary {
            parts.append(verse.text(in: secondary))
        }
        parts.append("— Verse \(verse.id), Chapter \(verse.chapter)")
        return parts.joined(separator: "\n\n")
    }

    private func chapterLink(_ chapter: Chapter) -> some View {
        NavigationLink(value: chapter) {
            GlassCard(isInteractive: true) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Read the chapter")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                        Text(chapter.title.text(in: settings.primary))
                            .font(settings.primary == .tibetan ? settings.primary.verseFont(size: 16) : .headline)
                            .lineSpacing(settings.primary == .tibetan ? 8 : 0)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer(minLength: 12)
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
        .environment(ReadingSettings.preview())
        .tint(Theme.crimson)
}
