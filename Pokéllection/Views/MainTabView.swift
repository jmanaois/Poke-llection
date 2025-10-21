import SwiftUI

struct MainTabView: View {
    @Binding var selectedTab: Int
    @Binding var lastSelectedTab: Int

    @EnvironmentObject var collectionVM: CollectionViewModel
    @EnvironmentObject var wishlistVM: WishlistViewModel
    @EnvironmentObject var searchVM: SearchViewModel

    var body: some View {
        TabView(selection: $selectedTab) {
            // 🔍 SEARCH TAB
            SearchView()
                .environmentObject(searchVM)
                .environmentObject(collectionVM)
                .environmentObject(wishlistVM)
                .tag(0)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            // 📦 COLLECTION TAB
            CollectionView()
                .environmentObject(collectionVM)
                .tag(1)
                .tabItem {
                    Label("Collection", systemImage: "rectangle.stack.fill")
                }

            // 💖 WISHLIST TAB
            WishlistView()
                .environmentObject(wishlistVM)
                .tag(2)
                .tabItem {
                    Label("Wishlist", systemImage: "heart.fill")
                }
        }
        // ✅ Detect when user re-taps the same tab
        .onChange(of: selectedTab) {
            if selectedTab == lastSelectedTab {
                if selectedTab == 0 {
                    // Reset Search when re-tapping Search tab
                    withAnimation(.easeInOut(duration: 0.3)) {
                        searchVM.query = ""
                        searchVM.results.removeAll()
                    }

                    // Dismiss keyboard if active
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
            lastSelectedTab = selectedTab
        }
    }
}
