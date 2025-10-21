import SwiftUI

struct SearchView: View {
    @EnvironmentObject var viewModel: SearchViewModel
    @EnvironmentObject var collectionVM: CollectionViewModel
    @EnvironmentObject var wishlistVM: WishlistViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.gradient.ignoresSafeArea()

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

                        // 🌐 Gradient-tinted Frosted Segmented Filter
                        ZStack {
                            // Gradient glow behind frosted blur
                            RoundedRectangle(cornerRadius: 14)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.blue.opacity(0.25),
                                            Color.purple.opacity(0.25)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .blur(radius: 10)

                            RoundedRectangle(cornerRadius: 14)
                                .fill(.ultraThinMaterial)
                                .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 1)

                            // Custom gradient label overlay
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

                        // 🩵 Loading shimmer
                        if viewModel.isLoading {
                            ScrollView {
                                LazyVStack(spacing: 12) {
                                    ForEach(0..<6, id: \.self) { _ in
                                        ShimmerCardPlaceholder()
                                    }
                                }
                                .padding()
                            }
                        }

                        // ❌ No results
                        else if viewModel.results.isEmpty && !viewModel.query.isEmpty {
                            ContentUnavailableView("no results found", systemImage: "magnifyingglass")
                                .padding(.vertical, 40)
                                .foregroundStyle(
                                    LinearGradient(colors: [.blue, .purple],
                                                   startPoint: .leading,
                                                   endPoint: .trailing)
                                )
                        }

                        // ✅ Grid of results
                        else {
                            ScrollView {
                                let columns = [GridItem(.adaptive(minimum: 160), spacing: 12)]

                                LazyVGrid(columns: columns, spacing: 16) {
                                    ForEach(viewModel.results) { card in
                                        NavigationLink(destination: CardDetailView(card: card)) {
                                            GridCardItem(card: card)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.top, 10)
                                .animation(.easeInOut, value: viewModel.results.count)
                            }
                        }
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
