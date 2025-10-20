import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @Binding var resetTrigger: Int

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ZStack {
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

                        // 🔍 Search field
                        TextField("Search cards...", text: $viewModel.query)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .onSubmit {
                                Task { await viewModel.searchCards() }
                            }

                        // 🔄 Loading state or results
                        if viewModel.isLoading {
                            ProgressView("Searching…")
                                .padding()
                        } else {
                            if viewModel.results.isEmpty && !viewModel.query.isEmpty {
                                ContentUnavailableView("No results found", systemImage: "magnifyingglass")
                                    .padding(.top, 40)
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
                            }
                        }
                    }
                    .padding(.bottom)
                }
                // 🧭 Reset behavior when tab re-tapped
                .onChange(of: resetTrigger) {
                    withAnimation(.easeInOut) {
                        viewModel.query = ""
                        viewModel.results = []
                        proxy.scrollTo(viewModel.results.first?.id, anchor: .top)
                    }
                }
            }
        }
        // 🚫 Remove navigation title to avoid duplication
        // (We use our own gradient title above)
    }
}
