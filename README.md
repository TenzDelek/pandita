# Pandita

A SwiftUI reader for iPhone. Three tabs — **Today**, **Chapters**, **Saved** — built against the
iOS 26 SDK so it picks up Liquid Glass natively. There is no backend: all text is decoded from a
JSON file in the app bundle, and the only writable state is local bookmarks.

## Requirements

- Xcode 26 or later
- iOS 26.0 deployment target (Liquid Glass APIs)
- Swift 6 language mode, strict concurrency
- A free or paid Apple Developer account (required to run on a physical iPhone)

## Run on a physical iPhone

Use **Xcode** — not Cursor — to build and install on a device.

### 1. Prepare your iPhone

1. Connect the iPhone to your Mac with a USB cable.
2. Unlock the phone and tap **Trust This Computer** if prompted.
3. On the iPhone, go to **Settings → Privacy & Security → Developer Mode** and turn it on (restart
   if asked).

### 2. Open the project in Xcode

```bash
open Pandita.xcodeproj
```

### 3. Configure signing

1. Select the **Pandita** project in the navigator, then the **Pandita** target.
2. Open **Signing & Capabilities**.
3. Check **Automatically manage signing**.
4. Choose your **Team** (sign in via **Xcode → Settings → Accounts** if needed).
5. Confirm the bundle identifier is `com.tenzindelek.Pandita`.

Xcode creates a development certificate and provisioning profile for your device.

### 4. Select your iPhone and run

1. In the **Xcode toolbar** (top center), open the scheme/destination picker and choose your iPhone
   — e.g. `Pandita > Tenzin's iPhone`. Do not pick a simulator.
2. Press **Run** (▶) in the top-left toolbar, or press `Cmd + R`.

The first install may require trusting the developer on the phone:

**Settings → General → VPN & Device Management → [Your Apple ID] → Trust**

### Command line (after signing is set up)

List connected devices:

```bash
xcrun xctrace list devices
```

Build for a specific device (replace the UDID):

```bash
xcodebuild -project Pandita.xcodeproj -scheme Pandita -destination 'platform=iOS,id=YOUR_DEVICE_UDID' build
```

### Troubleshooting

| Problem | Fix |
| --- | --- |
| iPhone not listed in Xcode | Use a data-capable cable, unlock the phone, trust the computer, open **Window → Devices and Simulators** |
| "Developer Mode required" | Enable Developer Mode on the iPhone (step 1) |
| Signing / provisioning errors | Set **Team** under Signing & Capabilities; sign in via **Xcode → Settings → Accounts** |
| "iOS 26.0 or later required" | Update the iPhone to iOS 26 |
| Untrusted developer | Trust the app under **Settings → General → VPN & Device Management** |

## Build and run (Simulator)

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
- Bundle id is `com.tenzindelek.Pandita`. See [Run on a physical iPhone](#run-on-a-physical-iphone) for signing setup.
- The app icon is a single 1024×1024 image in `AppIcon.appiconset`; iOS 26 derives the light, dark,
  and tinted treatments from it. To art-direct those separately, replace the set with an Icon
  Composer `.icon` file.
