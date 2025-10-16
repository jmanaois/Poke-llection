//
//  SearchViewModel.swift
//  Pokéllection
//
//  Created by Julian Manaois on 10/16/25.
//


import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    @Published var query = ""
    @Published var results: [Card] = []
    @Published var isLoading = false
    
    func searchCards() async {
        guard !query.isEmpty else { return }
        isLoading = true
        defer { isLoading = false }
        
        // Example API endpoint (replace with your own)
        let urlString = "https://api.example.com/cards?search=\(query)"
        
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode([Card].self, from: data)
            results = decoded
        } catch {
            print("Search error: \(error.localizedDescription)")
        }
    }
}