//
//  SafeAsyncImage.swift
//  Pokéllection
//
//  Created by Julian Manaois on 10/21/25.
//


import SwiftUI

struct SafeAsyncImage<Placeholder: View>: View {
    let url: URL?
    let placeholder: Placeholder
    let cornerRadius: CGFloat
    let retryCount: Int

    @State private var image: Image?
    @State private var loadFailed = false
    @State private var currentAttempt = 0

    init(url: URL?,
         cornerRadius: CGFloat = 8,
         retryCount: Int = 2,
         @ViewBuilder placeholder: () -> Placeholder) {
        self.url = url
        self.cornerRadius = cornerRadius
        self.retryCount = retryCount
        self.placeholder = placeholder()
    }

    var body: some View {
        ZStack {
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(cornerRadius)
                    .transition(.opacity.animation(.easeInOut(duration: 0.3)))
            } else if loadFailed {
                VStack {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 85)
                        .foregroundColor(.gray)
                    Text("Image unavailable")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } else {
                placeholder
                    .onAppear(perform: loadImage)
            }
        }
    }

    // MARK: - Image Loading with Retry
    private func loadImage() {
        guard let url = url else {
            loadFailed = true
            return
        }

        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                    throw URLError(.badServerResponse)
                }

                if let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        withAnimation { image = Image(uiImage: uiImage) }
                    }
                } else {
                    throw URLError(.cannotDecodeContentData)
                }
            } catch {
                if currentAttempt < retryCount {
                    currentAttempt += 1
                    try? await Task.sleep(nanoseconds: 300_000_000) // retry after 0.3s
                    loadImage()
                } else {
                    await MainActor.run { loadFailed = true }
                }
            }
        }
    }
}
