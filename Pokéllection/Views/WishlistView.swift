import SwiftUI

struct WishlistView: View {
    @EnvironmentObject var wishlistVM: WishlistViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.gradient.ignoresSafeArea()

                VStack(spacing: 16) {
                    // 🌈 Title
                    Text("wishlist")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(colors: [.blue, .purple],
                                           startPoint: .leading,
                                           endPoint: .trailing)
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 8)

                    if wishlistVM.wishlist.isEmpty {
                        ContentUnavailableView("your wishlist is empty", systemImage: "heart.fill")
                            .padding(.top, 60)
                            .foregroundStyle(
                                LinearGradient(colors: [.blue, .purple],
                                               startPoint: .leading,
                                               endPoint: .trailing)
                            )
                    } else {
                        ScrollView(.vertical, showsIndicators: true) {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 12)], spacing: 16) {
                                ForEach(wishlistVM.wishlist) { card in
                                    NavigationLink(destination: CardDetailView(card: card)) {
                                        VStack(spacing: 8) {
                                            SafeAsyncImage(url: card.imageURL, cornerRadius: 12) {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(Color.black.opacity(0.15))
                                                    ProgressView()
                                                }
                                                .frame(height: 180)
                                            }
                                            .frame(height: 180)
                                            .shadow(radius: 4)

                                            Text(card.name)
                                                .font(.system(size: 13, weight: .semibold))
                                                .foregroundColor(.primary)
                                                .multilineTextAlignment(.center)
                                                .lineLimit(2)
                                                .frame(height: 34)

                                            if let set = card.set_name {
                                                Text(set)
                                                    .font(.system(size: 11, weight: .medium))
                                                    .foregroundColor(.secondary)
                                                    .lineLimit(1)
                                            }
                                        }
                                        .padding(6)
                                        .frame(maxWidth: .infinity)
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(16)
                                        .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding()
                        }
                        .scrollContentBackground(.hidden)
                    }
                }
            }
        }
    }
}
