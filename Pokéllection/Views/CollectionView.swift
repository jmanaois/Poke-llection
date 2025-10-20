import SwiftUI

struct CollectionView: View {
    @EnvironmentObject var collectionVM: CollectionViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.gradient.ignoresSafeArea()

                VStack(spacing: 12) {
                    // Always show the title
                    Text("My Collection")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .foregroundStyle(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                        .padding(.top, 8)

                    if collectionVM.collection.isEmpty {
                        Spacer()
                        ContentUnavailableView(
                            "No cards yet",
                            systemImage: "rectangle.stack.fill",
                            description: Text("Search for cards and add them to your collection.")
                        )
                        Spacer()
                    } else {
                        List {
                            ForEach(collectionVM.collection) { card in
                                NavigationLink(destination: CardDetailView(card: card)) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(card.name)
                                            .font(.headline)
                                        if let set = card.set_name {
                                            Text(set)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                            .onDelete { indexSet in
                                indexSet.map { collectionVM.collection[$0] }
                                    .forEach(collectionVM.removeFromCollection)
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
        }
    }
}
