import SwiftUI
import Combine

@MainActor
class WishlistViewModel: ObservableObject {
    @CodableAppStorage("userWishlist") private var storedWishlist: [Card] = []
    private var cancellables = Set<AnyCancellable>()

    @Published private(set) var wishlist: [Card] = []

    init() {
        wishlist = storedWishlist

        $wishlist
            .dropFirst()
            .sink { [weak self] newValue in
                self?.storedWishlist = newValue
            }
            .store(in: &cancellables)
    }

    func addToWishlist(_ card: Card) {
        guard !wishlist.contains(where: { $0.id == card.id }) else { return }
        wishlist.append(card)
    }

    func removeFromWishlist(_ card: Card) {
        wishlist.removeAll { $0.id == card.id }
    }

    func contains(_ card: Card) -> Bool {
        wishlist.contains { $0.id == card.id }
    }
}
