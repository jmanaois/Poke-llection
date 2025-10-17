//
//  CollectionViewModel.swift
//  Pokéllection
//
//  Created by Julian Manaois on 10/16/25.
//

import SwiftUI
import Foundation
import Combine

@MainActor
class CollectionViewModel: ObservableObject {
    @Published var collection: [Card] = []

    func addToCollection(_ card: Card) {
        if !collection.contains(where: { $0.id == card.id }) {
            collection.append(card)
        }
    }

    func removeFromCollection(_ card: Card) {
        collection.removeAll(where: { $0.id == card.id })
    }

    func contains(_ card: Card) -> Bool {
        collection.contains(where: { $0.id == card.id })
    }
}
