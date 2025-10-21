//
//  Card.swift
//  Pokéllection
//
//  Created by Julian Manaois on 10/16/25.
//


import Foundation

struct Variant: Codable, Identifiable, Hashable {
    let id: String
    let condition: String?
    let printing: String?
    let language: String?
    let price: Double?           // current price
    let avgPrice90d: Double?
    let minPrice90d: Double?
    let maxPrice90d: Double?
}

struct Card: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let set_name: String?
    let variants: [Variant]?
    let tcgplayerId: String?
    
    var imageURL: URL? {
        guard let tcgID = tcgplayerId, !tcgID.isEmpty else { return nil }
        return URL(string: "https://tcgplayer-cdn.tcgplayer.com/product/\(tcgID)_in_1000x1000.jpg")
    }
}
