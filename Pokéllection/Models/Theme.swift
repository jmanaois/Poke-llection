import SwiftUI

struct Theme {
    static let background = Color(.systemGroupedBackground)
    static let cardBackground = Color(.secondarySystemBackground)
    static let accent = Color.blue
    static let accentSecondary = Color.pink
    static let shadow = Color.black.opacity(0.1)
    static let cornerRadius: CGFloat = 16
    static let glass = Color.white.opacity(0.25)
    
    // 🌀 Gradients
    static let gradient = LinearGradient(
        colors: [
            Color.blue.opacity(0.35),
            Color.purple.opacity(0.35)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(.systemBackground),
            Color(.systemGray6)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
}
