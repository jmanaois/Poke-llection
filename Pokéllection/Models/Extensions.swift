//
//  Extensions.swift
//  Pokéllection
//
//  Created by Julian Manaois on 10/17/25.
//


import Foundation

extension Double {
    func asCurrency(_ code: String = "USD") -> String {
        self.formatted(.currency(code: code))
    }
}