import SwiftUI

struct SearchView: View {
    @EnvironmentObject var viewModel: SearchViewModel
    @EnvironmentObject var collectionVM: CollectionViewModel
    @EnvironmentObject var wishlistVM: WishlistViewModel

    // ✅ Stable two-column layout (no UIScreen / GeometryReader)
    private let columns: [GridItem] = [
        GridItem(.flexible(minimum: 160), spacing: 14),
        GridItem(.flexible(minimum: 160), spacing: 14)
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                // 🌈 Gradient background
                Theme.gradient
                    .ignoresSafeArea()
                    .onTapGesture { hideKeyboard() }

                VStack(spacing: 16) {
                    // 🌀 Title
                    Text("search cards")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(colors: [.blue, .purple],
                                           startPoint: .leading,
                                           endPoint: .trailing)
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 8)

                    // 🔎 Query + Filter container
                    VStack(spacing: 14) {
                        // 🔍 Search field
                        TextField("search cards...", text: $viewModel.query)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .overlay(
                                HStack {
                                    Spacer()
                                    if !viewModel.query.isEmpty {
                                        Button {
                                            viewModel.query = ""
                                            viewModel.results.removeAll()
                                            hideKeyboard()
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.secondary)
                                                .padding(.trailing, 8)
                                        }
                                        .buttonStyle(.plain)
                                        .transition(.opacity)
                                        .animation(.easeInOut(duration: 0.15), value: viewModel.query.isEmpty)
                                    }
                                }
                            )
                            .padding(.horizontal)
                            .padding(.top, 10)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .onSubmit {
                                Task { await viewModel.searchCardsAnimated() }
                            }

                        // 🌐 Language filter (frosted)
                        ZStack {
                            RoundedRectangle(cornerRadius: 14)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.blue.opacity(0.25), Color.purple.opacity(0.25)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .blur(radius: 10)

                            RoundedRectangle(cornerRadius: 14)
                                .fill(.ultraThinMaterial)
                                .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 1)

                            HStack(spacing: 0) {
                                ForEach(viewModel.availableLanguages, id: \.self) { lang in
                                    Text(lang)
                                        .fontWeight(viewModel.selectedLanguage == lang ? .bold : .regular)
                                        .foregroundStyle(
                                            LinearGradient(
                                                colors: viewModel.selectedLanguage == lang
                                                    ? [.blue, .purple]
                                                    : [.secondary.opacity(0.6)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 6)
                                        .background(
                                            viewModel.selectedLanguage == lang
                                            ? Color(.systemBackground).opacity(0.25)
                                            : Color.clear
                                        )
                                        .cornerRadius(8)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            viewModel.selectedLanguage = lang
                                            Task { await viewModel.searchCards() }
                                        }
                                }
                            }
                            .padding(6)
                        }
                        .padding(.horizontal)
                        .frame(height: 44)
                        .shadow(color: .purple.opacity(0.2), radius: 8, x: 0, y: 4)
                        .animation(.easeInOut(duration: 0.25), value: viewModel.selectedLanguage)

                        Divider().padding(.horizontal)

                        // ✅ Results area
                        ScrollView(.vertical, showsIndicators: true) {
                            if viewModel.isLoading {
                                // 🩵 Shimmer grid (non-overlapping, fixed height)
                                LazyVGrid(columns: columns, spacing: 16) {
                                    ForEach(0..<8, id: \.self) { _ in
                                        ShimmerCardPlaceholder()
                                            .frame(height: 220)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(
                                                        LinearGradient(
                                                            colors: [.blue.opacity(0.15), .purple.opacity(0.15)],
                                                            startPoint: .topLeading,
                                                            endPoint: .bottomTrailing
                                                        )
                                                    )
                                            )
                                            .cornerRadius(12)
                                            .transition(.opacity)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.top, 10)
                            } else if viewModel.results.isEmpty && !viewModel.query.isEmpty {
                                // ❌ Centered empty state
                                VStack {
                                    Spacer(minLength: 100)
                                    ContentUnavailableView("no results found", systemImage: "magnifyingglass")
                                        .foregroundStyle(
                                            LinearGradient(colors: [.blue, .purple],
                                                           startPoint: .leading,
                                                           endPoint: .trailing)
                                        )
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal)
                            } else {
                                // ✅ Two-column grid of results
                                LazyVGrid(columns: columns, spacing: 16) {
                                    ForEach(viewModel.results) { card in
                                        NavigationLink(destination: CardDetailView(card: card)) {
                                            GridCardItem(card: card)
                                                .transition(.opacity.combined(with: .scale))
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.top, 10)
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .modifier(KeyboardDismissOnScroll())
                    }
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
                    .padding(.horizontal)
                }
                .padding(.bottom)
            }
        }
    }
}



#if canImport(UIKit)
extension View {
    /// Hides the keyboard manually
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

/// 🧠 Modifier: auto-dismiss keyboard while scrolling (iOS 15+ support)
struct KeyboardDismissOnScroll: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.scrollDismissesKeyboard(.immediately)
        } else {
            content.gesture(
                DragGesture().onChanged { _ in
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder),
                        to: nil,
                        from: nil,
                        for: nil
                    )
                }
            )
        }
    }
}
#endif
