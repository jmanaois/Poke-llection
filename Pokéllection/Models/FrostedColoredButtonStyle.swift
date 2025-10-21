
import SwiftUI

struct FrostedColoredButtonStyle: ButtonStyle {
    var color: Color
    var overlayOpacity: Double = 0.18
    var strokeOpacity: Double = 0.30
    var pressedScale: CGFloat = 0.98

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            .foregroundStyle(color)
            .frame(maxWidth: .infinity, minHeight: 50) // ✅ Stable height
            .background(.ultraThinMaterial)
            .overlay(color.opacity(overlayOpacity))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color.opacity(strokeOpacity), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: color.opacity(0.18), radius: 10, x: 0, y: 4)
            .scaleEffect(configuration.isPressed ? pressedScale : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.8),
                       value: configuration.isPressed)
    }
}
