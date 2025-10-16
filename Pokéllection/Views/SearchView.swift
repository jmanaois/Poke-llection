//
//  SearchView.swift
//  Pokéllection
//
//  Created by Julian Manaois on 10/16/25.
//


import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @EnvironmentObject var collectionVM: CollectionViewModel
    @EnvironmentObject var wishlistVM: WishlistViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search cards...", text: $viewModel.query)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onSubmit {
                        Task { await viewModel.searchCards() }
                    }

                if viewModel.isLoading {
                    ProgressView("Searching...")
                } else {
                    List(viewModel.results) { card in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(card.name).font(.headline)
                                if let url = card.imageURL, let imgURL = URL(string: url) {
                                    AsyncImage(url: imgURL) { image in
                                        image.resizable()
                                             .aspectRatio(contentMode: .fit)
                                             .frame(height: 100)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                            }
                            Spacer()
                            Menu {
                                Button("Add to Collection") {
                                    collectionVM.add(card)
                                }
                                Button("Add to Wishlist") {
                                    wishlistVM.add(card)
                                }
                            } label: {
                                Image(systemName: "plus.circle")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Search")
        }
    }
}