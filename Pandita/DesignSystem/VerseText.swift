import SwiftUI

/// A verse rendered in one language, with the type treatment that language needs.
struct VerseText: View {
    let text: String
    let language: ReadingLanguage
    var size: CGFloat = 19
    var isSecondary: Bool = false
    /// Overrides the adaptive colour. Set this over artwork, where `.primary`
    /// would flip to black in light mode on top of a dark fade.
    var tint: Color?

    /// Not `.secondary` for the parallel language: over artwork it washes out.
    /// A dimmed primary holds its contrast on every background.
    private var foreground: AnyShapeStyle {
        let base: Color = tint ?? .primary
        return AnyShapeStyle(isSecondary ? base.opacity(0.75) : base)
    }

    var body: some View {
        Text(text)
            .font(language.verseFont(size: isSecondary ? size - 3 : size))
            .lineSpacing(isSecondary ? language.verseLineSpacing * 0.7 : language.verseLineSpacing)
            .foregroundStyle(foreground)
            .frame(maxWidth: .infinity, alignment: .leading)
            // Tibetan and Chinese carry no language tag in the JSON, so state it
            // for VoiceOver rather than letting it guess from the glyphs.
            .accessibilityLabel(text)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 20) {
        ForEach(ReadingLanguage.allCases) { language in
            VerseText(text: Library.preview.allVerses[0].text(in: language), language: language)
        }
    }
    .padding()
}
