//
//  WishlistViewModel.swift
//  Pokéllection
//
//  Created by Julian Manaois on 10/16/25.
//

import SwiftUI
import Foundation
import Combine

@MainActor

class WishlistViewModel: ObservableObject {
    @Published var wishlist: [Card] = []

    func addToWishlist(_ card: Card) {
        if !wishlist.contains(where: { $0.id == card.id }) {
            wishlist.append(card)
        }
    }

    func removeFromWishlist(_ card: Card) {
        wishlist.removeAll(where: { $0.id == card.id })
    }

    func contains(_ card: Card) -> Bool {
        wishlist.contains(where: { $0.id == card.id })
    }
}
