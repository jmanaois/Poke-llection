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
    let avgPrice: Double?
    let minPrice7d: Double?
    let maxPrice7d: Double?
}

struct Card: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let set_name: String?
    let variants: [Variant]?
}
