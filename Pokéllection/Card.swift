import Foundation

struct Card: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let imageURL: String?
}