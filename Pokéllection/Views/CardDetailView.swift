import SwiftUI
import UIKit

struct CardDetailView: View {
    let card: Card
    @EnvironmentObject var collectionViewModel: CollectionViewModel
    @EnvironmentObject var wishlistViewModel: WishlistViewModel
    @State private var dominantColor: Color = Color.blue.opacity(0.25)
    @State private var textColor: Color = .white // adaptive based on image brightness

    var body: some View {
        ZStack {
            // 🌈 Dynamic gradient based on card image color
            LinearGradient(
                colors: [dominantColor, dominantColor.opacity(0.5), .purple.opacity(0.25)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // 🖼 Card Image
                    AsyncImage(url: card.imageURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView().frame(height: 300)
                        case .success(let image):
                            image.resizable()
                                .scaledToFit()
                                .cornerRadius(12)
                                .shadow(radius: 8)
                                .padding(.horizontal)
                                .onAppear {
                                    if let uiImage = image.asUIImage(),
                                       let uiColor = uiImage.averageColor {
                                        let swiftUIColor = Color(uiColor)
                                        dominantColor = swiftUIColor
                                        textColor = uiColor.isLight ? .black : .white
                                    }
                                }
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }

                    // 🧾 Card Info
                    VStack(spacing: 6) {
                        Text(card.name)
                            .font(.system(size: 30, weight: .heavy, design: .rounded))
                            .foregroundColor(Color.primary.opacity(ColorScheme.current == .dark ? 0.85 : 0.7))
                            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                            .shadow(color: .white.opacity(0.3), radius: 1, x: 0, y: -1)
                            .multilineTextAlignment(.center)

                        if let setName = card.set_name {
                            Text(setName)
                                .font(.headline)
                                .foregroundColor(Color.primary.opacity(ColorScheme.current == .dark ? 0.85 : 0.7))
                                .multilineTextAlignment(.center)
                        }
                        
                        // 💰 Pricing
                        if let lowest = lowestMarketPrice {
                            VStack(spacing: 8) {
                                Text("Market: \(lowest)")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.35), radius: 3, x: 0, y: 1)

                                if let min = minPrice90d, let max = maxPrice90d {
                                    HStack(spacing: 12) {
                                        Label {
                                            Text("low: \(min)")
                                                .font(.system(size: 14, weight: .medium))
                                        } icon: {
                                            Image(systemName: "arrow.down")
                                                .font(.system(size: 12, weight: .semibold))
                                        }

                                        Label {
                                            Text("high: \(max)")
                                                .font(.system(size: 14, weight: .medium))
                                        } icon: {
                                            Image(systemName: "arrow.up")
                                                .font(.system(size: 12, weight: .semibold))
                                        }
                                    }
                                    .foregroundColor(.white.opacity(0.95))
                                    .shadow(color: .black.opacity(0.35), radius: 3, x: 0, y: 1)
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.black.opacity(0.35))
                                    .background(
                                        VisualEffectBlur(blurStyle: .systemMaterialDark)
                                            .clipShape(RoundedRectangle(cornerRadius: 14))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                                    )
                            )
                            .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
                            .padding(.horizontal)
                            .padding(.top, 6)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                    // 💾 Buttons
                    HStack(spacing: 16) {
                        frostedButton(
                            isActive: collectionViewModel.contains(card),
                            activeColor: .red,
                            inactiveColor: .blue,
                            activeIcon: "minus.circle.fill",
                            inactiveIcon: "plus.circle.fill",
                            activeText: "- collection",
                            inactiveText: "+ collection"
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                if collectionViewModel.contains(card) {
                                    collectionViewModel.removeFromCollection(card)
                                } else {
                                    collectionViewModel.addToCollection(card)
                                }
                            }
                        }

                        frostedButton(
                            isActive: wishlistViewModel.contains(card),
                            activeColor: .red,
                            inactiveColor: .pink,
                            activeIcon: "heart.slash.fill",
                            inactiveIcon: "heart.fill",
                            activeText: "- wishlist",
                            inactiveText: "+ wishlist"
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                if wishlistViewModel.contains(card) {
                                    wishlistViewModel.removeFromWishlist(card)
                                } else {
                                    wishlistViewModel.addToWishlist(card)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                .padding()
            }
        }
        .navigationTitle(card.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    // 🧮 Helper: lowest variant price
    private var lowestMarketPrice: String? {
        guard let variants = card.variants else { return nil }
        let prices = variants.compactMap { $0.price }
        guard let minPrice = prices.min() else { return nil }
        return minPrice.asCurrency()
    }
    
    // 🧮 Helper: average pricing metrics
    private var minPrice90d: String? {
        guard let variants = card.variants else { return nil }
        let prices = variants.compactMap { $0.minPrice90d }
        guard let min = prices.min() else { return nil }
        return min.asCurrency()
    }

    private var maxPrice90d: String? {
        guard let variants = card.variants else { return nil }
        let prices = variants.compactMap { $0.maxPrice90d }
        guard let max = prices.max() else { return nil }
        return max.asCurrency()
    }

    // 🪟 Custom frosted button
    @ViewBuilder
    private func frostedButton(
        isActive: Bool,
        activeColor: Color,
        inactiveColor: Color,
        activeIcon: String,
        inactiveIcon: String,
        activeText: String,
        inactiveText: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Spacer(minLength: 0)
                Image(systemName: isActive ? activeIcon : inactiveIcon)
                    .font(.system(size: 16, weight: .semibold))
                Text(isActive ? activeText : inactiveText)
                    .font(.system(size: 13.5, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .multilineTextAlignment(.center)
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 42)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isActive ? activeColor.opacity(0.4) : inactiveColor.opacity(0.4),
                                    lineWidth: 1)
                    )
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

//
// MARK: - Helpers for image color & brightness
//
extension Image {
    func asUIImage() -> UIImage? {
        let renderer = ImageRenderer(content: self)
        return renderer.uiImage
    }
}

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x,
                                    y: inputImage.extent.origin.y,
                                    z: inputImage.extent.size.width,
                                    w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage",
                                    parameters: [kCIInputImageKey: inputImage,
                                                 kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext()
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: CGColorSpaceCreateDeviceRGB())

        return UIColor(
            red: CGFloat(bitmap[0]) / 255,
            green: CGFloat(bitmap[1]) / 255,
            blue: CGFloat(bitmap[2]) / 255,
            alpha: 1
        )
    }

}

extension UIColor {

    var isLight: Bool {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)

        // Perceived brightness formula
        let brightness = (r * 299 + g * 587 + b * 114) / 1000
        return brightness > 0.6
    }
}

extension ColorScheme {
    static var current: ColorScheme {
        UITraitCollection.current.userInterfaceStyle == .dark ? .dark : .light
    }
}
