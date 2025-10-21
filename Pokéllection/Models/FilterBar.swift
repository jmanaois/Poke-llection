//
//  FilterBar.swift
//  Pokéllection
//
//  Created by Julian Manaois on 10/21/25.
//


import SwiftUI

struct FilterBar: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            // 🈳 Language menu
            Menu {
                Picker("Language", selection: $viewModel.selectedLanguage) {
                    ForEach(viewModel.availableLanguages, id: \.self) { Text($0) }
                }
            } label: {
                Label(viewModel.selectedLanguage == "All" ? "Language" : viewModel.selectedLanguage, systemImage: "globe")
            }
            .onChange(of: viewModel.selectedLanguage) {
                Task { await viewModel.searchCardsAnimated() }
            }
            .font(.subheadline)
            .padding(.horizontal)
            .padding(.bottom, 6)
            .foregroundColor(.secondary)
            .onChange(of: viewModel.selectedLanguage) {
                Task { await viewModel.searchCardsAnimated() }
            }
            
        }
    }
}
