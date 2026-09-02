import SwiftUI

/// The three-tab shell. Each tab owns its own `NavigationStack` so pushed
/// screens stay scoped to their tab.
struct RootTabView: View {
    @State private var selection: AppTab = .today

    var body: some View {
        TabView(selection: $selection) {
            Tab(AppTab.today.title, systemImage: AppTab.today.symbol, value: .today) {
                TodayView()
            }
            Tab(AppTab.chapters.title, systemImage: AppTab.chapters.symbol, value: .chapters) {
                ChaptersView()
            }
            Tab(AppTab.saved.title, systemImage: AppTab.saved.symbol, value: .saved) {
                SavedView()
            }
        }
        // Liquid Glass: the tab bar shrinks out of the way as the reader scrolls down.
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}

#Preview {
    RootTabView()
        .environment(LibraryStore.preview())
        .environment(SavedStore.preview())
        .environment(ReadingSettings.preview())
        .tint(Theme.crimson)
}
