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
    @State var viewModel: PokemonListViewModel
    let dimensions: Double = 140
    let item: PokemonListPresentableItem
    
    @ViewBuilder var detailView: some View {
        if let _ = self.pokemonDetail {
            backgroundImage
            VStack {
                pokemonImage
                VStack(alignment: .leading) {
                    nameView
                    ForEach(getTypes(), id: \.name) { elementType in
                        RoundedTextView(text: elementType.name.capitalized(with: .current),
                                        cornerRadius: 12)
                    }
                }
            }
        }else {
            VStack(alignment: .center) {
                loadingView
            }
        }
    }
    
    var body: some View {
        ZStack() {
            detailView
        }
        .padding(10)
        .background(getBackgroundColor())
        .cornerRadius(16.0)
        .onAppear {
            viewModel.fetchDetails(with: item.index){ response in
                pokemonDetail = PokemonDetailPresentableItem(domainModel: response) 
            }
        }
    }
    
    var loadingView: some View {
        HStack(spacing: 10) {
            ProgressView()
                .progressViewStyle(.circular)
        }
        .frame(width: 110,height: 218)
    }
    
    var backgroundImage: some View {
        Image("pokeBallIcon")
            .resizable()
            .scaledToFit()
            .frame(minWidth: 0, maxWidth: 100, minHeight: 0, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            .opacity(0.1)
    }
    
    var pokemonImage: some View {
        WebImage(url: ImageUrl.getURL(index: idex))
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
    }
    
    var idex: String {
        item.index.description
    }
    
    var nameView: some View {
        Text(item.name)
            .font(.system(size: 16, weight: .bold, design: .default))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
    
    func getTypes() -> [TypeElementPresentableItem] {
        guard let types = pokemonDetail?.types else { return [] }
        return types
    }
    
    func getBackgroundColor() -> Color {
        guard let name = pokemonDetail?.types?.first?.name else { return Color("normalColor") }
        return pokemonDetail?.getColorForSpecies(name.lowercased()) ?? Color("normalColor")
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


