//
//  ShimmerCardPlaceholder.swift
//  Pokéllection
//
//  Created by Julian Manaois on 10/21/25.
//
import SwiftUI

struct ShimmerCardPlaceholder: View {
    @State private var shimmer = false

    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 60, height: 85)
                .shimmer(active: shimmer)

            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 150, height: 16)
                    .shimmer(active: shimmer)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 14)
                    .shimmer(active: shimmer)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .background(Color(.systemBackground).opacity(0.15))
        .cornerRadius(12)
        .onAppear {
            shimmer = true
        }
    }
}

extension View {
    func shimmer(active: Bool) -> some View {
        self
            .overlay(
                GeometryReader { geometry in
                    if active {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.2),
                                Color.white.opacity(0.6),
                                Color.white.opacity(0.2)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .rotationEffect(.degrees(30))
                        .offset(x: geometry.size.width * 1.5)
                        .mask(self)
                        .animation(
                            .linear(duration: 1.4)
                                .repeatForever(autoreverses: false),
                            value: active
                        )
                    }
                }
            )
    }
}
