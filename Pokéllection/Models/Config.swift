//
//  Config.swift
//  Pokéllection
//
//  Created by Julian Manaois on 10/16/25.
//


// Config.swift
import Foundation

enum Config {
    static var apiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            fatalError("⚠️ Missing API_KEY in Info.plist")
        }
        return key
    }
}
