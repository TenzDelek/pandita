# Pandita

A SwiftUI reader for iPhone. Three tabs — **Today**, **Chapters**, **Saved** — built against the
iOS 26 SDK so it picks up Liquid Glass natively.

The text is the *Sakya Legshé*, 457 verses in nine chapters, carried in Tibetan, English, and
Chinese. There is no backend: everything is decoded from a JSON file in the app bundle, and the
only writable state is the reader's bookmarks and language choice.

## Requirements

- Xcode 26 or later
- iOS 26.0 deployment target (Liquid Glass APIs)
- Swift 6 language mode, strict concurrency

## Build and run

```bash
xcodebuild -project Pandita.xcodeproj -scheme Pandita -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build
```

```bash
xcodebuild -project Pandita.xcodeproj -scheme Pandita -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test
```

## Layout

```
Pandita/
  App/            PanditaApp, RootTabView, AppTab
  Models/         Library → Chapter → Verse, ReadingLanguage, LocalizedText
  Data/           ContentRepository seam, stores, preview fixtures
  DesignSystem/   Theme, GlassCard, VerseCard, VerseText, SaveButton, LanguageMenu
  Features/       Today, Chapters, Saved — one folder per tab
  Resources/      content.json, Assets.xcassets
PanditaTests/     Swift Testing suites
```

The Xcode target uses a **synchronized folder group**, so anything you drop into `Pandita/` is
compiled automatically — no `project.pbxproj` edits when adding a file.

## Content

`Pandita/Resources/content.json` is the entire dataset. The models mirror its shape exactly, so
the file can be regenerated and dropped straight in with no transform step:

```json
{
  "chapters": [
    {
      "id": 1,
      "title": {
        "tibetan": "ལེའུ་དང་པོ། མཁས་པ་བརྟག་པ།",
        "english": "Chapter 1 - An Examination of the Wise",
        "chinese": "第一章 辨智者篇"
      },
      "verseRange": { "start": 1, "end": 30 },
      "verses": [
        { "id": 1, "chapter": 1, "tibetan": "…", "english": "…", "chinese": "…" }
      ]
    }
  ]
}
```

Invariants the app relies on, each covered by a test in `ContentDecodingTests`:

- **Verse `id` is the global verse number and must be stable across content revisions.** Bookmarks
  are stored by it; an id that shifts silently moves someone's bookmark to a different verse.
  `SavedStore.savedVerses(in:)` drops ids it can't resolve.
- Ids run `1...n` in reading order, with no gaps or duplicates.
- `verseRange` matches the first and last verse actually in the chapter, and every verse's
  `chapter` field matches its parent.
- No verse or chapter title is missing any of the three languages — there is no fallback path.

Regenerate the file and the suite tells you which invariant broke before the app ever ships it.

## Languages

All three languages are always present, so there is no fallback logic. The reader picks a language
to read in and, optionally, a second shown beneath it — a parallel reading is how this text is
normally studied, so it is a first-class setting rather than a hidden toggle. Both live in
`ReadingSettings`, persist across launches, and are reachable from the toolbar on every screen.

The two can never be the same language: choosing the parallel language as the primary one clears
the parallel slot, rather than hiding the duplicate at render time and letting it spring back.

Each script gets the type treatment it needs — Tibetan is set in Kailasa with a taller line box for
its stacked glyphs, English in a serif face, Chinese between the two. Search runs across all three
at once and returns matching verses rather than whole chapters, which is the only useful shape at
457 verses.

## Artwork

The Today hero is one of seven illustrations, rotated by calendar day the same way the verse is —
deterministic, so it stays put all day and nothing needs storing. The art carries no meaning tied to
a particular verse; nothing in the text maps onto it, so the pairing is deliberately just a rotation.

The card is editorial rather than glass: artwork runs full-bleed and fades into a dark tone taken
from that illustration's own palette, with the verse set in white over the faded half. A frosted
panel here would hide the art it exists to show — glass stays on the controls, where it belongs.
Each case carries its own `fadeColor` so the fade reads as part of the image, not a grey wash over
it.

To add a piece: drop an imageset into `Assets.xcassets` and add a case to `HeroArtwork` whose raw
value is the asset name. `HeroArtworkTests` checks the rotation still covers every case.

## Architecture

`ContentRepository` is the seam between the app and its data. Today the only real implementation is
`BundleContentRepository`; swapping in a downloaded or generated payload later means writing one new
conformance and changing the single line in `PanditaApp` that constructs `LibraryStore`.

State is three `@MainActor @Observable` stores injected through the environment, not singletons:

- `LibraryStore` — loads the text once, exposes `idle / loading / loaded / failed`
- `SavedStore` — bookmarked verse numbers, newest first, in `UserDefaults`
- `ReadingSettings` — the reading language and the parallel one

## Liquid Glass

The app opts *in* to the iOS 26 look by simply building against the iOS 26 SDK — there is no
`UIDesignRequiresCompatibility` key, and adding one would opt back out.

System containers (tab bar, navigation bars, search field, lists, menus) get glass for free and are
deliberately left unstyled. Glass is applied by hand only on custom surfaces:

| Where | API |
| --- | --- |
| `RootTabView` | `.tabBarMinimizeBehavior(.onScrollDown)` |
| `GlassCard` | `.glassEffect(_:in:)`, `Glass.tint(_:)`, `Glass.interactive()` |
| Today hero | `GlassEffectContainer` + `.glassEffectID(_:in:)` so the card and buttons morph as one |
| Save / Share | `.buttonStyle(.glass)`, `.buttonStyle(.glassProminent)` |
| Scroll views | `.scrollEdgeEffectStyle(.soft, for: .top)` |

## Notes

- iPhone only (`TARGETED_DEVICE_FAMILY = 1`), portrait. Widen in the target's build settings.
- Bundle id is `com.tenzindelek.Pandita`; set `DEVELOPMENT_TEAM` before building to a device.
- UI chrome ("Verses 1–30", tab titles) stays in the device language while the *text* follows the
  reading language. Localising the chrome too would be a separate pass.
- The app icon is a single 1024×1024 image in `AppIcon.appiconset`; iOS 26 derives the light, dark,
  and tinted treatments from it. To art-direct those separately, replace the set with an Icon
  Composer `.icon` file.
