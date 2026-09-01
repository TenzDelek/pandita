# Pandita

A SwiftUI reader for iPhone. Three tabs — **Today**, **Chapters**, **Saved** — built against the
iOS 26 SDK so it picks up Liquid Glass natively. There is no backend: all text is decoded from a
JSON file in the app bundle, and the only writable state is local bookmarks.

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
  Models/         Library → Chapter → Verse (Codable, Sendable)
  Data/           ContentRepository seam, stores, preview fixtures
  DesignSystem/   Theme, GlassCard, VerseCard, SaveButton
  Features/       Today, Chapters, Saved — one folder per tab
  Resources/      content.json, Assets.xcassets
PanditaTests/       Swift Testing suites
```

The Xcode target uses a **synchronized folder group**, so anything you drop into `Pandita/` is
compiled automatically — no `project.pbxproj` edits when adding a file.

## Content

`Pandita/Resources/content.json` is the entire dataset. Replace its contents with the real text:

```json
{
  "version": 1,
  "title": "Pandita",
  "chapters": [
    {
      "id": "ch-01",
      "number": 1,
      "title": "The Wise",
      "subtitle": "Optional",
      "verses": [
        { "id": "v-1-1", "number": 1, "text": "…", "commentary": "Optional" }
      ]
    }
  ]
}
```

Two rules:

- **Verse `id`s must be stable across content revisions.** Bookmarks are stored by id; an id that
  changes silently loses its bookmark. `SavedStore.savedVerses(in:)` drops ids it can't resolve.
- Bump `version` if the schema changes, so `BundleContentRepository` can migrate instead of throw.

`ContentDecodingTests` fails the build if the bundled JSON stops decoding or two verses share an id.

## Architecture

`ContentRepository` is the seam between the app and its data. Today the only real implementation is
`BundleContentRepository`; swapping in a downloaded or generated payload later means writing one new
conformance and changing the single line in `PanditaApp` that constructs `LibraryStore`.

State is two `@MainActor @Observable` stores injected through the environment, not singletons:

- `LibraryStore` — loads the text once, exposes `idle / loading / loaded / failed`
- `SavedStore` — bookmark ids, newest first, persisted in `UserDefaults`

## Liquid Glass

The app opts *in* to the iOS 26 look by simply building against the iOS 26 SDK — there is no
`UIDesignRequiresCompatibility` key, and adding one would opt back out.

System containers (tab bar, navigation bars, search field, lists) get glass for free and are
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
- The app icon is a single 1024×1024 image in `AppIcon.appiconset`; iOS 26 derives the light, dark,
  and tinted treatments from it. To art-direct those separately, replace the set with an Icon
  Composer `.icon` file.
