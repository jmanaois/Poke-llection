import SwiftUI

@main
struct PokellectionApp: App {
    @StateObject private var collectionVM = CollectionViewModel()
    @StateObject private var wishlistVM = WishlistViewModel()
    @StateObject private var searchVM = SearchViewModel() // ✅ Added

    @State private var selectedTab = 0
    @State private var lastSelectedTab = 0
    @State private var showLaunch = true

    init() {
        // 🌈 Customize navigation & tab bar appearance globally
        let navBar = UINavigationBarAppearance()
        navBar.configureWithOpaqueBackground()
        navBar.backgroundEffect = UIBlurEffect(style: .systemThinMaterial)
        navBar.backgroundColor = UIColor.clear
        UINavigationBar.appearance().standardAppearance = navBar
        UINavigationBar.appearance().scrollEdgeAppearance = navBar

        let tabBar = UITabBarAppearance()
        tabBar.configureWithDefaultBackground()
        UITabBar.appearance().standardAppearance = tabBar
        UITabBar.appearance().scrollEdgeAppearance = tabBar
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showLaunch {
                    LaunchView()
                        .transition(.opacity)
                } else {
                    MainTabView(
                        selectedTab: $selectedTab,
                        lastSelectedTab: $lastSelectedTab
                    )
                    // ✅ Inject SearchViewModel for SearchView access
                    .environmentObject(searchVM)
                    .environmentObject(collectionVM)
                    .environmentObject(wishlistVM)
                    .transition(.opacity)
                    // ✅ Detect re-tapping the same tab (Swift 5.9 / iOS 17 syntax)
                    .onChange(of: selectedTab) {
                        if selectedTab == lastSelectedTab {
                            if selectedTab == 0 {
                                // 🔄 Reset search when tapping Search again
                                searchVM.query = ""
                                searchVM.results.removeAll()
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) // Dismiss keyboard
                            }
                        }
                        lastSelectedTab = selectedTab
                    }
                }
            }
            .onAppear {
                // ⏱ Brief launch animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        showLaunch = false
                    }
                }
            }
        }
    }
}
