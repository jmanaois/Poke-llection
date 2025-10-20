
import SwiftUI

struct GradientBackground: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Theme.gradient.ignoresSafeArea()
            content
        }
    }
}

extension View {
    func gradientBackground() -> some View {
        modifier(GradientBackground())
    }
}
