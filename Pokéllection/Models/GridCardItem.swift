import SwiftUI

struct GridCardItem: View {
    let card: Card

    // 🧮 Helper to find the lowest market price across variants
    private var marketPrice: String? {
        guard let variants = card.variants else { return nil }
        let prices = variants.compactMap { $0.price }
        guard let minPrice = prices.min() else { return nil }
        return minPrice.asCurrency()
    }

    var body: some View {
        VStack(spacing: 6) {
            AsyncImage(url: card.imageURL) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                        ProgressView()
                    }
                    .frame(height: 160)
                case .success(let image):
                    image.resizable()
                        .scaledToFit()
                        .frame(height: 160)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                case .failure:
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                            .font(.system(size: 28))
                    }
                    .frame(height: 160)
                @unknown default:
                    EmptyView()
                }
            }

            VStack(spacing: 2) {
                Text(card.name)
                    .font(.headline)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)

                if let set = card.set_name {
                    Text(set)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }

                // 💰 Display price under set name
                if let price = marketPrice {
                    Text("\(price)")
                        .font(.caption2)
                        .foregroundStyle(
                            LinearGradient(colors: [.green, .mint],
                                           startPoint: .leading,
                                           endPoint: .trailing)
                        )
                        .padding(.top, 2)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(8)
        .background(.ultraThinMaterial)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
