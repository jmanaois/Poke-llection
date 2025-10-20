import SwiftUI

@main
struct PokellectionApp: App {
    @StateObject private var collectionVM = CollectionViewModel()
    @StateObject private var wishlistVM = WishlistViewModel()
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
                    .environmentObject(collectionVM)
                    .environmentObject(wishlistVM)
                    .transition(.opacity)
                }
            }
            .onAppear {
                // ⏱ Show the launch screen briefly
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        showLaunch = false
                    }
                }
            }
        }
    }
}
