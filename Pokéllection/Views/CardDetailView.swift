import SwiftUI

struct CardDetailView: View {
    let card: Card
    @EnvironmentObject var collectionViewModel: CollectionViewModel
    @EnvironmentObject var wishlistViewModel: WishlistViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 📝 Card name and set
                VStack(alignment: .leading, spacing: 8) {
                    Text(card.name)
                        .font(.title)
                        .bold()
                    if let setName = card.set_name {
                        Text("Set: \(setName)")
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                // 💰 Compact price summary
                if let summary = compactPriceSummary(for: card) {
                    VStack(spacing: 4) {
                        Text("Market: \(summary.market)")
                            .font(.headline)
                        Text("Low: \(summary.low) · High: \(summary.high)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                } else {
                    Text("No pricing data available.")
                        .foregroundColor(.secondary)
                        .padding()
                }
                
                // 🪙 Detailed variant list
                if let variants = card.variants, !variants.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Variants")
                            .font(.headline)
                        ForEach(variants) { variant in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(variant.condition ?? "Unknown Condition")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                HStack(spacing: 8) {
                                    if let market = variant.price ?? variant.avgPrice {
                                        Text("Market: \(market.asCurrency())")
                                    }
                                    if let low = variant.minPrice7d {
                                        Text("Low: \(low.asCurrency())")
                                    }
                                    if let high = variant.maxPrice7d {
                                        Text("High: \(high.asCurrency())")
                                    }
                                }
                                .font(.footnote)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                // 💾 Wishlist / Collection buttons
                VStack(spacing: 12) {
                    collectionButton
                    wishlistButton
                }
                .padding(.top)
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle(card.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Adaptive Buttons
    
    private var collectionButton: some View {
        let isInCollection = collectionViewModel.contains(card)
        
        return Button {
            withAnimation(.spring()) {
                if isInCollection {
                    collectionViewModel.removeFromCollection(card)
                } else {
                    collectionViewModel.addToCollection(card)
                }
            }
        } label: {
            Label(
                isInCollection ? "In Collection" : "Add to Collection",
                systemImage: isInCollection ? "checkmark.circle.fill" : "plus.circle"
            )
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(isInCollection ? Color.green.opacity(0.15) : Color.blue)
            .foregroundColor(isInCollection ? .green : .white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
            .animation(.spring(), value: isInCollection)
        }
    }
    
    private var wishlistButton: some View {
        let isInWishlist = wishlistViewModel.contains(card)
        
        return Button {
            withAnimation(.spring()) {
                if isInWishlist {
                    wishlistViewModel.removeFromWishlist(card)
                } else {
                    wishlistViewModel.addToWishlist(card)
                }
            }
        } label: {
            Label(
                isInWishlist ? "In Wishlist" : "Add to Wishlist",
                systemImage: isInWishlist ? "heart.fill" : "heart"
            )
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(isInWishlist ? Color.pink.opacity(0.15) : Color.pink)
            .foregroundColor(isInWishlist ? .pink : .white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
            .animation(.spring(), value: isInWishlist)
        }
    }
    
    private func compactPriceSummary(for card: Card) -> (market: String, low: String, high: String)? {
        guard let variants = card.variants, !variants.isEmpty else { return nil }
        
        let marketPrices = variants.compactMap { $0.price ?? $0.avgPrice }
        let lowPrices    = variants.compactMap { $0.minPrice7d }
        let highPrices   = variants.compactMap { $0.maxPrice7d }
        
        guard let market = marketPrices.first,
              let low    = lowPrices.min(),
              let high   = highPrices.max() else { return nil }
        
        return (market.asCurrency(), low.asCurrency(), high.asCurrency())
    }
}
