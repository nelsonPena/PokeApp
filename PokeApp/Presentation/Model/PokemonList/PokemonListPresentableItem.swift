//
//  PokemonListPresentableItem.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 14/10/23.
//

import Foundation

struct PokemonListPresentableItem: PokemonDetailProtocol {
    
    var index: Int
    var abilities: [AbilityPresentableItem]?
    var name: String
    var types: [TypeElementPresentableItem]?
    let url: String
    
    internal init(domainModel: ResultElement) {
        self.name = domainModel.name.capitalized(with: .current)
        self.url = domainModel.url
        self.index = domainModel.index
    }
    
    internal init(savedModel: SavedPokemon) {
        self.name = savedModel.name.capitalized(with: .current)
        self.url = savedModel.url
        self.index = savedModel.index
    }
}

extension PokemonListPresentableItem {
    func getTypes(name: String) -> [TypeElementPresentableItem]? {
        return self.types?.filter { $0.name.lowercased().contains(name)}
    }
}
