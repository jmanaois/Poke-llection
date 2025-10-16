//
//  CollectionViewModel.swift
//  Pokéllection
//
//  Created by Julian Manaois on 10/16/25.
//

import SwiftUI
import Foundation
internal import Combine

@MainActor
class CollectionViewModel: ObservableObject {
    @Published var collection: [Card] = []
    
    func add(_ card: Card) {
        if !collection.contains(card) {
            collection.append(card)
        }
    }
    
    func remove(_ card: Card) {
        collection.removeAll { $0 == card }
    }
}
