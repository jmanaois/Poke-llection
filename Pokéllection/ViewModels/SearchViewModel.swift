import SwiftUI
import Foundation
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    @Published var query = ""
    @Published var results: [Card] = []
    @Published var isLoading = false

    // Filters (language only for now)
    @Published var selectedLanguage: String = "all"
    @Published var availableLanguages: [String] = ["all", "english", "japanese"]

    // MARK: - Card Search (stable + fuzzy)
    func searchCards() async {
        // Clear when empty
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            results = []
            return
        }

        isLoading = true
        defer { isLoading = false }

        // Build URL with URLComponents
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.justtcg.com"
        components.path = "/v1/cards"

        // Use the fuzzy contains pattern that previously worked for you
        // e.g. q="*charizard*"
        let qValue = "*\(query)*"

        components.queryItems = [
            URLQueryItem(name: "q", value: qValue)
        ]

        guard let url = components.url else {
            print("❌ Could not build URL from components: \(components)")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(Config.apiKey, forHTTPHeaderField: "x-api-key")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        print("🔎 Requesting: \(url.absoluteString)")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                print("❌ HTTP \(http.statusCode)")
                if let body = String(data: data, encoding: .utf8) { print("Body: \(body)") }
                return
            }

            struct APIResponse: Codable { let data: [Card] }
            let decoded = try JSONDecoder().decode(APIResponse.self, from: data)

            // Client-side language filter (variants.language)
            let rawCards = decoded.data
            let filteredByLanguage: [Card]
            if selectedLanguage == "all" {
                filteredByLanguage = rawCards
            } else {
                let langLower = selectedLanguage.lowercased()
                filteredByLanguage = rawCards.filter { card in
                    guard let variants = card.variants else { return false }
                    return variants.contains { $0.language?.lowercased() == langLower }
                }
            }

            results = filteredByLanguage
            print("✅ Loaded \(rawCards.count) cards, \(filteredByLanguage.count) after language filter (\(selectedLanguage))")

            // Optional: DEBUG peek at first few names
            filteredByLanguage.prefix(5).forEach {
                print("• \($0.name) — set: \($0.set_name ?? $0.set_name ?? "N/A")")
            }

        } catch {
            print("❌ Network/decoding error: \(error)")
            // Helpful: print response body if decoding failed
            if let body = String(data: (try? await URLSession.shared.data(for: request).0) ?? Data(), encoding: .utf8) {
                print("Body (retry peek): \(body)")
            }
        }
    }

    // MARK: - Animated Search (kept)
    func searchCardsAnimated() async {
        await searchCards()
        let fetched = results
        results = []
        for (i, card) in fetched.enumerated() {
            try? await Task.sleep(nanoseconds: 80_000_000)
            withAnimation(.spring().delay(Double(i) * 0.03)) {
                results.append(card)
            }
        }
    }
}
