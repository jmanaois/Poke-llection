//
//  Card.swift
//  Pokéllection
//
//  Created by Julian Manaois on 10/16/25.
//


import Foundation

struct Card: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let imageURL: String?
}
