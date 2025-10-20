import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @Binding var resetTrigger: Int

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ZStack {
                    // ✨ Gradient background
                    Theme.gradient.ignoresSafeArea()

                    VStack(spacing: 16) {
                        // 🌀 Gradient title
                        Text("Search Cards")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(colors: [.blue, .purple],
                                               startPoint: .leading,
                                               endPoint: .trailing)
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top, 8)

                        // 💎 Frosted glass panel for search + list
                        VStack(spacing: 12) {
                            // 🔍 Search bar
                            TextField("Search cards...", text: $viewModel.query)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal)
                                .padding(.top, 12)
                                .onSubmit {
                                    Task { await viewModel.searchCards() }
                                }

                            Divider().padding(.horizontal)

                            // 📄 Results or placeholder
                            if viewModel.isLoading {
                                ProgressView("Searching…")
                                    .padding()
                            } else if viewModel.results.isEmpty && !viewModel.query.isEmpty {
                                ContentUnavailableView("No results found",
                                                       systemImage: "magnifyingglass")
                                    .padding(.vertical, 40)
                            } else {
                                List(viewModel.results) { card in
                                    NavigationLink(destination: CardDetailView(card: card)) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(card.name)
                                                .font(.headline)
                                            if let setName = card.set_name {
                                                Text(setName)
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                        .padding(.vertical, 6)
                                    }
                                    .id(card.id)
                                }
                                .listStyle(.plain)
                                .scrollContentBackground(.hidden)
                                .frame(maxHeight: 500)
                            }
                        }
                        .padding(.bottom, 12)
                        .background(.ultraThinMaterial) // 🌫️ Frosted glass
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
                        .padding(.horizontal)
                        .animation(.easeInOut(duration: 0.25), value: viewModel.results)
                    }
                    .padding(.bottom)
                }
                // 🔁 Reset search when tab is re-tapped
                .onChange(of: resetTrigger) {
                    withAnimation(.easeInOut) {
                        viewModel.query = ""
                        viewModel.results = []
                        proxy.scrollTo(viewModel.results.first?.id, anchor: .top)
                    }
                }
            }
        }
    }
}
