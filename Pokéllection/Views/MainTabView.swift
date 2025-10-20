
import SwiftUI

struct MainTabView: View {
    @Binding var selectedTab: Int
    @Binding var lastSelectedTab: Int

    var body: some View {
        TabView(selection: $selectedTab) {
            SearchView(resetTrigger: $selectedTab)
                .tag(0)
                .tabItem { Label("Search", systemImage: "magnifyingglass") }

            CollectionView()
                .tag(1)
                .tabItem { Label("Collection", systemImage: "rectangle.stack.fill") }

            WishlistView()
                .tag(2)
                .tabItem { Label("Wishlist", systemImage: "heart.fill") }
        }
        .tint(Theme.accent)
        .onChange(of: selectedTab) { oldValue, newValue in
            if newValue == lastSelectedTab {
                selectedTab = -1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    selectedTab = newValue
                }
            }
            lastSelectedTab = newValue
        }
    }
}
