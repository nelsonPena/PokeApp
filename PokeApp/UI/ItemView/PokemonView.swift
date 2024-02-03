//
//  PokemonView.swift
//  MVVMPokedex
//
//  Created by Federico on 30/03/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import Combine

struct PokemonView: View {
    
    @State var pokemonDetail: PokemonDetailPresentableItem?
    @State private var cancellables: Set<AnyCancellable> = Set()
    @State public var showLoading = false
    @State var viewModel: PokemonListViewModel
    let dimensions: Double = 140
    let item: PokemonListPresentableItem
    
    var body: some View {
        ZStack() {
            if showLoading {
                VStack(alignment: .center) {
                    loadingView
                }
            }else {
                Image("pokeBallIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 0, maxWidth: 100, minHeight: 0, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.1)
                VStack {
                    WebImage(url: URL(string: String(format: Bundle.main.infoDictionary?["ImageUrl"] as? String ?? "", item.index.description)))
                        .resizable()
                        .placeholder(Image(systemName: "photo"))
                        .placeholder {
                            Rectangle().foregroundColor(.clear)
                        }
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8.0)
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.system(size: 16, weight: .bold, design: .default))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        ForEach(getTypes(), id: \.slot) { elementType in
                            RoundedTextView(text: elementType.type.name.capitalized(with: .current),
                                            cornerRadius: 12)
                        }
                    }
                }
            }
        }
        .padding(10)
        .background(getBackgroundColor())
        .cornerRadius(16.0)
        .onAppear {
            viewModel.fetchDetails(id: item.index){ response in
                pokemonDetail = response
            }
        }
    }
    
    private var loadingView: some View {
        HStack(spacing: 10) {
            ProgressView().progressViewStyle(.circular)
        }.background(Color.white)
    }
    
    func getTypes() -> [TypeElementPresentableItem] {
        guard let types = pokemonDetail?.types else { return [] }
        return types
    }
    
    func getBackgroundColor() -> Color {
        guard let name = pokemonDetail?.types?.first?.type.name else { return .white }
        return pokemonDetail?.getColorForSpecies(name.lowercased()) ?? .white
    }
    
    struct RoundedTextView: View {
        let text: String
        let cornerRadius: CGFloat
        
        var body: some View {
            Text(text)
                .padding(10)
                .font(.system(size: 14, weight: .medium, design: .default))
                .foregroundColor(.black)
                .background(.white.opacity(0.5))
                .cornerRadius(cornerRadius)
                .lineLimit(1)
        }
    }
}


