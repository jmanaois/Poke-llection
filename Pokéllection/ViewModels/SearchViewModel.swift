//
//  SearchViewModel.swift
//  Pokéllection
//
//  Created by Julian Manaois on 10/16/25.
//

import SwiftUI
import Foundation
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    @Published var query = ""
    @Published var results: [Card] = []
    @Published var isLoading = false
    
    func searchCards() async {
        guard !query.isEmpty else {
            results = []
            return
        }
        isLoading = true
        defer { isLoading = false }
        
        // Encode query
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        // Construct URL
        let urlString = "https://api.justtcg.com/v1/cards?q=\(encoded)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Add the JustTCG API key header
        request.addValue(Config.apiKey, forHTTPHeaderField: "x-api-key")
        
        // Optionally, some APIs want a content type or accept header
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let http = response as? HTTPURLResponse {
                print("HTTP status code: \(http.statusCode)")
                print("Response headers: \(http.allHeaderFields)")
                if !(200...299).contains(http.statusCode) {
                    // check non-success status
                    print("❌ Server replied with status \(http.statusCode)")
                    // You can also print the body for debugging
                    if let bodyStr = String(data: data, encoding: .utf8) {
                        print("Body: \(bodyStr)")
                    }
                    return
                }
            }
            print("✅ Loaded \(results.count) cards")

            for card in results.prefix(5) {
                print("🃏 \(card.name) - Variants: \(card.variants?.count ?? 0)")
                if let variants = card.variants {
                    for variant in variants {
                        print("   💰 \(variant.condition ?? "Unknown"): Market \(variant.market_price ?? -1)")
                    }
                }
            }
            // If JSON shape is nested, decode appropriately
            struct APIResponse: Codable {
                let data: [Card]
            }
            
            let decoded = try JSONDecoder().decode(APIResponse.self, from: data)
            results = decoded.data
            
            // 🧪 TEST: Print debug info for image URLs
            print("✅ Loaded \(results.count) cards")
            
        } catch {
            print("❌ Network or decoding error: \(error)")
        }
    }
}
