import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search cards...", text: $viewModel.query)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onSubmit {
                        Task { await viewModel.searchCards() }
                    }
                
                if viewModel.isLoading {
                    ProgressView("Searching…")
                        .padding()
                } else {
                    List(viewModel.results) { card in
                        NavigationLink(destination: CardDetailView(card: card)) {
                            HStack(alignment: .center, spacing: 16) {
                               

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(card.name)
                                        .font(.headline)
                                    if let setName = card.set_name {
                                        Text(setName)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Search Cards")
        }
    }
}
