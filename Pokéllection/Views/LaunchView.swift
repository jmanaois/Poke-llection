
import SwiftUI

struct LaunchView: View {
    @State private var fadeOut = false

    var body: some View {
        ZStack {
            Theme.gradient
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "sparkles")
                    .font(.system(size: 56))
                    .foregroundStyle(.white)
                    .symbolEffect(.bounce, options: .repeating, value: fadeOut)

                Text("Pokéllection")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                    .opacity(fadeOut ? 0 : 1)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.2)) {
                    fadeOut = true
                }
            }
        }
    }
}
