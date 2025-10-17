//
//  CollectionView.swift
//  Pokéllection
//
//  Created by Julian Manaois on 10/16/25.
//


import SwiftUI

struct CollectionView: View {
    @EnvironmentObject var collectionVM: CollectionViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(collectionVM.collection) { card in
                    Text(card.name)
                }
                .onDelete { indexSet in
                    // Delete each selected card properly
                    indexSet.map { collectionVM.collection[$0] }
                        .forEach { card in
                            collectionVM.removeFromCollection(card)
                        }
                }
            }
            .navigationTitle("My Collection")
        }
    }
}
