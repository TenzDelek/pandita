import SwiftUI

/// Toolbar control for switching the reading language and the parallel one
/// shown beneath it. Placed on every screen that renders verses.
struct LanguageMenu: View {
    @Environment(ReadingSettings.self) private var settings

    var body: some View {
        @Bindable var settings = settings

        Menu {
            // The reading language sits at the top level so it is one tap away.
            // A Section header would say so, but iOS drops section headers in a
            // menu that holds an inline Picker, which left the two groups
            // indistinguishable — hence the labelled submenu below instead.
            Picker("Read in", selection: $settings.primary) {
                ForEach(ReadingLanguage.allCases) { language in
                    Text(language.label).tag(language)
                }
            }
            .pickerStyle(.inline)

            Menu {
                Picker("Alongside", selection: $settings.secondary) {
                    Text("None").tag(ReadingLanguage?.none)
                    ForEach(settings.secondaryOptions) { language in
                        Text(language.label).tag(ReadingLanguage?.some(language))
                    }
                }
                .pickerStyle(.inline)
            } label: {
                Label(
                    "Alongside: \(settings.secondary?.label ?? "None")",
                    systemImage: "rectangle.split.1x2"
                )
            }
        } label: {
            Label("Language", systemImage: "character.book.closed")
        }
        .accessibilityLabel("Reading language")
    }
}
