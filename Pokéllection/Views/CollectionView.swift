import SwiftUI

struct CollectionView: View {
    @EnvironmentObject var collectionVM: CollectionViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.gradient.ignoresSafeArea()

                VStack(spacing: 16) {
                    // 🌈 Gradient Title
                    Text("my collection")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(colors: [.blue, .purple],
                                           startPoint: .leading,
                                           endPoint: .trailing)
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 8)

                    if collectionVM.collection.isEmpty {
                        ContentUnavailableView("your collection is empty",
                                               systemImage: "rectangle.stack.fill")
                            .padding(.top, 60)
                            .foregroundStyle(
                                LinearGradient(colors: [.blue, .purple],
                                               startPoint: .leading,
                                               endPoint: .trailing)
                            )
                    } else {
                        ScrollView {
                            let columns = [GridItem(.adaptive(minimum: 160), spacing: 12)]
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(collectionVM.collection) { card in
                                    NavigationLink(destination: CardDetailView(card: card)) {
                                        VStack(spacing: 8) {
                                            // 🖼 Safe image loading
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

                                            // 🏷 Card Name
                                            Text(card.name)
                                                .font(.system(size: 13, weight: .semibold))
                                                .foregroundColor(.primary)
                                                .multilineTextAlignment(.center)
                                                .lineLimit(2)
                                                .frame(height: 34)

                                            // 📦 Set Name
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
                                        .scaleEffect(1.0)
                                        .animation(.spring(response: 0.3, dampingFraction: 0.8),
                                                   value: collectionVM.collection)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                        }
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom)
            }
        }
    }
}
