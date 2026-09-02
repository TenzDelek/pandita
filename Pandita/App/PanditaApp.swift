import SwiftUI

@main
struct PanditaApp: App {
    /// App-lifetime state. Each store is `@MainActor @Observable` and handed
    /// down through the environment rather than referenced as singletons.
    @State private var library = LibraryStore()
    @State private var saved = SavedStore()
    @State private var settings = ReadingSettings()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(library)
                .environment(saved)
                .environment(settings)
                .tint(Theme.crimson)
                .task { await library.loadIfNeeded() }
        }
    }
}
