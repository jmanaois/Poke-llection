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
    let market_price: Double?
    let low_price: Double?
    let high_price: Double?
}

struct Card: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let set_name: String?
    let variants: [Variant]?
}
