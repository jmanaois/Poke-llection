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
                    indexSet.map { collectionVM.collection[$0] }.forEach(collectionVM.remove)
                }
            }
            .navigationTitle("My Collection")
        }
    }
}
