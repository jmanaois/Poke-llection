//
//  Item.swift
//  Pokéllection
//
//  Created by Julian Manaois on 10/16/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
