import SwiftUI

/// The biography drawer. Opens at half height so the verse stays partly in
/// view, and can be dragged up to full for the whole text.
struct AuthorSheet: View {
    let author: Author

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    portrait

                    VStack(alignment: .leading, spacing: 24) {
                        heading
                        ForEach(author.sections) { section in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(section.heading)
                                    .font(.headline)
                                Text(section.body)
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                    .lineSpacing(3)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(pageBackground)
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    private var portrait: some View {
        // The frame is established by an empty container and the image drawn
        // into it as an overlay. Sizing the image itself left it free to
        // resolve differently against the medium and large detents, which is
        // what put gutters down the sides at medium and left the fade painting
        // over blank space instead of over the artwork.
        Color.clear
            .frame(height: 300)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .top) {
                Image(author.portraitAsset)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .clipped()
            .overlay(alignment: .bottom) {
                // Fades the crop into the page rather than ending on a seam.
                LinearGradient(
                    stops: [
                        .init(color: pageBackground.opacity(0), location: 0),
                        .init(color: pageBackground.opacity(0.6), location: 0.55),
                        .init(color: pageBackground, location: 1)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 120)
                .allowsHitTesting(false)
            }
            .accessibilityLabel("Thangka of \(author.name)")
    }

    /// Painted behind the page and used as the fade's end colour, so the two
    /// are the same colour by construction rather than by coincidence.
    private var pageBackground: Color { Color(.systemBackground) }

    private var heading: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(author.tibetanName)
                .font(ReadingLanguage.tibetan.verseFont(size: 19))
                .lineSpacing(10)

            Text(author.name)
                .font(.title2.weight(.semibold))

            HStack(spacing: 8) {
                Text(author.lifespan)
                Text("·")
                Text(author.chineseName)
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)

            Text(author.epithet)
                .font(.callout)
                .foregroundStyle(.secondary)
                .padding(.top, 4)
        }
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            AuthorSheet(author: .sakyaPandita)
        }
}
