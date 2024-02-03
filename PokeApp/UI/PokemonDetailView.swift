//
//  PokemonDetailView.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 14/10/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct PokemonDetailView: View {
    
    @ObservedObject private var viewModel: PokemonDetailViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(viewModel: PokemonDetailViewModel, viewData: PokemonDetailViewData) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    var body: some View {
        HStack(alignment: .top) {
            if viewModel.showLoadingSpinner {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                // Pokemon Details
                VStack() {
                    ScrollView {
                        VStack(alignment: .center, spacing: 20) {
                            // Pokemon Image
                            pokemonImage
                            // Pokemon Name
                            pokemonName
                            // Details
                            pokemonDetaisTitle
                            ForEach(getSkills(), id: \.name) { skill in
                                DetailRow(label: "text_skill".localized,
                                          value: skill.name,
                                          isStatus: false,
                                          color: .cyan)
                            }
                            DetailRow(label: "text_height".localized,
                                      value: viewModel.PokemonDetailPresentable.height.description,
                                      isStatus: false,
                                      color: .black)
                            DetailRow(label: "text_weight".localized,
                                      value: viewModel.PokemonDetailPresentable.weight.description,
                                      isStatus: false,
                                      color: .black)
                        }
                        .padding(20)
                    }
                    Spacer()
                    DoneButton(action: { self.presentationMode.wrappedValue.dismiss() })
                }.padding(20)
            }
        }
        .navigationBarTitle("detail_title".localized)
        .navigationBarTitleDisplayMode(.large)
        .onReceive(viewModel.$goBack) { goBack in
            if goBack {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    var pokemonImage: some View {
        WebImage(url: ImageUrl.getURL(index: index))
            .resizable()
            .placeholder(Image(systemName: "photo"))
            .placeholder {
                Rectangle().foregroundColor(.gray)
            }
            .indicator(.activity)
            .transition(.fade(duration: 0.5))
            .scaledToFill()
            .frame(maxWidth: 200,
                   alignment: .center)
            .cornerRadius(8.0)
    }
    
    var pokemonName: some View {
        Text(viewModel.PokemonDetailPresentable.name)
            .font(.system(size: 30, weight: .bold))
            .accessibilityIdentifier("nameLabel")
            .frame(maxWidth: .infinity,
                   alignment: .center)
            .foregroundColor(.black)
    }
    
    var pokemonDetaisTitle: some View {
        Text("text_skills".localized)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.system(size: 17, weight: .bold))
    }
    
    func getSkills() -> [AbilityPresentableItem] {
        viewModel.PokemonDetailPresentable.abilities ?? []
    }
    
    var index: String {
        viewModel.PokemonDetailPresentable.index.description
    }
}

// MARK: - Detail Row View

struct DetailRow: View {
    let label: String
    let value: String
    let isStatus: Bool
    let color: Color
    
    var body: some View {
        HStack {
            Text(label)
                .accessibilityIdentifier("text_\(label.lowercased())")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 17, weight: .bold))
            
            Text(value)
                .accessibilityIdentifier("value_\(label.lowercased())")
                .foregroundColor(color)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - Done Button View

struct DoneButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("text_done_button".localized)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
        .accessibilityIdentifier("doneButton")
        .padding()
        .foregroundColor(.white)
        .background(.black)
        .cornerRadius(100)
    }
}
