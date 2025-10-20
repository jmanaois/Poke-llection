import SwiftUI

struct WishlistView: View {
    @EnvironmentObject var wishlistVM: WishlistViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.gradient.ignoresSafeArea()

                VStack(spacing: 12) {
                    // Always show the title
                    Text("Wishlist")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .foregroundStyle(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                        .padding(.top, 8)

                    if wishlistVM.wishlist.isEmpty {
                        Spacer()
                        ContentUnavailableView(
                            "No wishlist cards",
                            systemImage: "heart",
                            description: Text("Add cards you’re interested in collecting later.")
                        )
                        Spacer()
                    } else {
                        List {
                            ForEach(wishlistVM.wishlist) { card in
                                NavigationLink(destination: CardDetailView(card: card)) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(card.name)
                                            .font(.headline)
                                        if let set = card.set_name {
                                            Text(set)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                            .onDelete { indexSet in
                                indexSet.map { wishlistVM.wishlist[$0] }
                                    .forEach(wishlistVM.removeFromWishlist)
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
        }
    }
}
