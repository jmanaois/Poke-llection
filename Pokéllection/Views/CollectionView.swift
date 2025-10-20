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
