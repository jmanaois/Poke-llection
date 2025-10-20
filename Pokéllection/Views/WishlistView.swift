//
//  WishlistView.swift
//  Pokéllection
//
//  Created by Julian Manaois on 10/16/25.
//

import SwiftUI

struct WishlistView: View {
    @EnvironmentObject var wishlistVM: WishlistViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(wishlistVM.wishlist) { card in
                    NavigationLink(destination: CardDetailView(card: card)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(card.name)
                                .font(.headline)
                            if let setName = card.set_name {
                                Text(setName)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .onDelete { indexSet in
                    indexSet.map { wishlistVM.wishlist[$0] }
                        .forEach { card in
                            wishlistVM.removeFromWishlist(card)
                        }
                }
            }
            .navigationTitle("Wishlist")
        }
    }
}
