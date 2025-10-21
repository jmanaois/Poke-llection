//
//  SearchResultRow.swift
//  Pokéllection
//
//  Created by Julian Manaois on 10/21/25.
//


import SwiftUI

struct SearchResultRow: View {
    let card: Card

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: card.imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView().frame(width: 60, height: 85)
                case .success(let image):
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 85)
                        .cornerRadius(8)
                        .shadow(radius: 3)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 85)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(card.name)
                    .font(.headline)
                if let setName = card.set_name ?? card.set_name {
                    Text(setName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .background(Color(.systemBackground).opacity(0.15))
        .cornerRadius(12)
    }
}
