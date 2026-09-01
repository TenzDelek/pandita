import SwiftUI

@main
struct PanditaApp: App {
    /// App-lifetime state. Both stores are `@MainActor @Observable` and handed
    /// down through the environment rather than referenced as singletons.
    @State private var library = LibraryStore()
    @State private var saved = SavedStore()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(library)
                .environment(saved)
                .tint(Theme.crimson)
                .task { await library.loadIfNeeded() }
        }
    }
}
