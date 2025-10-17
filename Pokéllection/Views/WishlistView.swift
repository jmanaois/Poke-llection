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
                    Text(card.name)
                }
                .onDelete { indexSet in
                    // Delete each selected card properly
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

