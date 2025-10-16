//
//  WishlistViewModel.swift
//  Pokéllection
//
//  Created by Julian Manaois on 10/16/25.
//

import SwiftUI
import Foundation
internal import Combine

@MainActor
class WishlistViewModel: ObservableObject {
    @Published var wishlist: [Card] = []
    
    func add(_ card: Card) {
        if !wishlist.contains(card) {
            wishlist.append(card)
        }
    }
    
    func remove(_ card: Card) {
        wishlist.removeAll { $0 == card }
    }
}
