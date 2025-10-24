import SwiftUI

@main
struct PokellectionApp: App {
    @StateObject private var collectionVM = CollectionViewModel()
    @StateObject private var wishlistVM = WishlistViewModel()
    @StateObject private var searchVM = SearchViewModel()

    @State private var selectedTab = 0
    @State private var lastSelectedTab = 0
    @State private var showLaunch = true

    init() {
        // 🌈 Customize navigation bar
        let navBar = UINavigationBarAppearance()
        navBar.configureWithOpaqueBackground()
        navBar.backgroundEffect = UIBlurEffect(style: .systemThinMaterial)
        navBar.backgroundColor = UIColor.clear
        navBar.titleTextAttributes = [
            .foregroundColor: UIColor(
                gradientBetween: .systemBlue,
                and: .systemPurple,
                fraction: 0.8
            )
        ]
        UINavigationBar.appearance().standardAppearance = navBar
        UINavigationBar.appearance().scrollEdgeAppearance = navBar

        // 🟣 Customize tab bar with gradient icon glow
        let tabBar = UITabBarAppearance()
        tabBar.configureWithDefaultBackground()

        tabBar.backgroundEffect = UIBlurEffect(style: .systemThinMaterial)
        tabBar.backgroundColor = UIColor.clear

        // Inactive state
        tabBar.stackedLayoutAppearance.normal.iconColor = UIColor(
            gradientBetween: .systemBlue,
            and: .systemPurple,
            fraction: 0.4
        )
        tabBar.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(
                gradientBetween: .systemBlue,
                and: .systemPurple,
                fraction: 0.4
            )
        ]

        // Active (selected) icon + title color
        tabBar.stackedLayoutAppearance.selected.iconColor = .white
        tabBar.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        // 🟦 Add gradient capsule background under selected icon
        let gradientImage = UIImage.gradientCapsule(
            colors: [.systemBlue, .systemPurple],
            size: CGSize(width: 60, height: 28)
        )

        // Apply to the tab bar’s selected indicator
        tabBar.selectionIndicatorImage = gradientImage
            .resizableImage(withCapInsets: .zero, resizingMode: .stretch)
            .withRenderingMode(.alwaysOriginal)

        // Apply globally
        UITabBar.appearance().standardAppearance = tabBar
        UITabBar.appearance().scrollEdgeAppearance = tabBar
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showLaunch {
                    LaunchView()
                        .transition(.opacity)
                } else {
                    MainTabView(
                        selectedTab: $selectedTab,
                        lastSelectedTab: $lastSelectedTab
                    )
                    .environmentObject(searchVM)
                    .environmentObject(collectionVM)
                    .environmentObject(wishlistVM)
                    .transition(.opacity)
                    .onChange(of: selectedTab) {
                        if selectedTab == lastSelectedTab {
                            if selectedTab == 0 {
                                searchVM.query = ""
                                searchVM.results.removeAll()
                                UIApplication.shared.sendAction(
                                    #selector(UIResponder.resignFirstResponder),
                                    to: nil,
                                    from: nil,
                                    for: nil
                                )
                            }
                        }
                        lastSelectedTab = selectedTab
                    }
                }
            }
            .onAppear {
                // ⏱ Launch animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        showLaunch = false
                    }
                }
            }
        }
    }
}

// MARK: - Gradient UIColor Helper
extension UIColor {
    convenience init(gradientBetween first: UIColor, and second: UIColor, fraction: CGFloat) {
        var fRed: CGFloat = 0, fGreen: CGFloat = 0, fBlue: CGFloat = 0, fAlpha: CGFloat = 0
        var sRed: CGFloat = 0, sGreen: CGFloat = 0, sBlue: CGFloat = 0, sAlpha: CGFloat = 0

        first.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha)
        second.getRed(&sRed, green: &sGreen, blue: &sBlue, alpha: &sAlpha)

        let red = fRed + (sRed - fRed) * fraction
        let green = fGreen + (sGreen - fGreen) * fraction
        let blue = fBlue + (sBlue - fBlue) * fraction
        let alpha = fAlpha + (sAlpha - fAlpha) * fraction

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

// MARK: - Gradient Capsule Image Helper
extension UIImage {
    static func gradientCapsule(colors: [UIColor], size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size),
                                    cornerRadius: size.height / 2)
            let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: colors.map { $0.cgColor } as CFArray,
                locations: [0.0, 1.0]
            )!
            context.cgContext.saveGState()
            context.cgContext.addPath(path.cgPath)
            context.cgContext.clip()
            context.cgContext.drawLinearGradient(
                gradient,
                start: CGPoint(x: 0, y: 0),
                end: CGPoint(x: size.width, y: 0),
                options: []
            )
            context.cgContext.restoreGState()
        }
    }
}
