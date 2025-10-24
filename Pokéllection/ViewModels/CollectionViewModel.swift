import SwiftUI
import Combine

@MainActor
class CollectionViewModel: ObservableObject {
    @CodableAppStorage("userCollection") private var storedCollection: [Card] = []
    private var cancellables = Set<AnyCancellable>()

    // Expose as @Published proxy
    @Published private(set) var collection: [Card] = []

    init() {
        collection = storedCollection
        
        // Automatically sync AppStorage <-> Published
        $collection
            .dropFirst()
            .sink { [weak self] newValue in
                self?.storedCollection = newValue
            }
            .store(in: &cancellables)
    }

    func addToCollection(_ card: Card) {
        guard !collection.contains(where: { $0.id == card.id }) else { return }
        collection.append(card)
    }

    func removeFromCollection(_ card: Card) {
        collection.removeAll { $0.id == card.id }
    }

    func contains(_ card: Card) -> Bool {
        collection.contains { $0.id == card.id }
    }
}
