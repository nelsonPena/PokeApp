//
//  PokemonDetailPresentableItem.swift
//  PokeApp
//
//  Created by Nelson Peña on 2/02/24.
//

import SwiftUI

struct PokemonDetailPresentableItem: PokemonDetailProtocol {
 
    var index: Int
    var abilities: [AbilityPresentableItem]?
    var height: Int
    var name: String
    var weight: Int
    var types: [TypeElementPresentableItem]?
    
    init(domainModel: PokemonDetail) {
        self.index = domainModel.index
        self.abilities = domainModel.abilities.map{ $0.mapper() }
        self.height = domainModel.height
        self.name = domainModel.name.capitalized(with: .current)
        self.weight = domainModel.weight
        self.types = domainModel.types.map{ $0.mapper() }
    }
    
    func getColorForSpecies(_ speciesName: String) -> Color {
      Color("\(speciesName)Color")
    }
}
