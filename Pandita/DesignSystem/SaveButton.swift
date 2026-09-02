import SwiftUI

/// Bookmark toggle for a verse. Reads and writes `SavedStore` directly so every
/// surface showing that verse stays in sync.
///
/// Deliberately unstyled: callers apply `.buttonStyle(.glass)` on free-floating
/// surfaces and leave toolbar copies plain, where the bar already provides glass.
struct SaveButton: View {
    let verseID: Verse.ID
    var showsLabel: Bool = false

    @Environment(SavedStore.self) private var saved

    private var isSaved: Bool { saved.isSaved(verseID) }

    var body: some View {
        Button {
            withAnimation(.snappy) { saved.toggle(verseID) }
        } label: {
            if showsLabel {
                Label(isSaved ? "Saved" : "Save", systemImage: symbol)
            } else {
                Image(systemName: symbol)
            }
        }
        .accessibilityLabel(isSaved ? "Remove bookmark" : "Bookmark verse")
        .sensoryFeedback(.selection, trigger: isSaved)
    }

    private var symbol: String {
        isSaved ? "bookmark.fill" : "bookmark"
    }
}

#Preview {
    HStack(spacing: 12) {
        SaveButton(verseID: 1).buttonStyle(.glass)
        SaveButton(verseID: 2, showsLabel: true).buttonStyle(.glassProminent)
    }
    .environment(SavedStore.preview(saving: [1]))
}
