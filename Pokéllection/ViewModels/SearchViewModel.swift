//
//  SearchViewModel.swift
//  Pokéllection
//
//  Created by Julian Manaois on 10/16/25.
//

import SwiftUI
import Foundation
internal import Combine

@MainActor
class SearchViewModel: ObservableObject {
    @Published var query = ""
    @Published var results: [Card] = []
    @Published var isLoading = false

    func searchCards() async {
        guard !query.isEmpty else { return }
        isLoading = true
        defer { isLoading = false }

        // Example: Scryfall or other API endpoint
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.justtcg.com/v1\(encodedQuery)"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.addValue(Config.apiKey, forHTTPHeaderField: "Authorization")
        // OR, if your API uses a header like `X-API-Key`:
        // request.addValue(Config.apiKey, forHTTPHeaderField: "X-API-Key")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode([Card].self, from: data)
            results = decoded
        } catch {
            print("API error: \(error.localizedDescription)")
        }
    }
}
