import SwiftUI
import Foundation

@main
struct Pokellection: App {
    @StateObject private var collectionVM = CollectionViewModel()
    @StateObject private var wishlistVM = WishlistViewModel()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                SearchView()
                    .environmentObject(collectionVM)
                    .environmentObject(wishlistVM)
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }

                CollectionView()
                    .environmentObject(collectionVM)
                    .tabItem {
                        Label("Collection", systemImage: "rectangle.stack.fill")
                    }

                WishlistView()
                    .environmentObject(wishlistVM)
                    .tabItem {
                        Label("Wishlist", systemImage: "heart.fill")
                    }
            }
            .environmentObject(collectionVM)
            .environmentObject(wishlistVM)
        }
    }
}
