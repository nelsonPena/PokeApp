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
    var species: SpeciesPresentableItem
    var weight: Int
    var types: [TypeElementPresentableItem]?
    
    init(domainModel: PokemonDetail) {
        self.index = domainModel.index
        self.abilities = domainModel.abilities.map{ $0.mapper() }
        self.height = domainModel.height
        self.name = domainModel.name.capitalized(with: .current)
        self.species = domainModel.species.mapper()
        self.weight = domainModel.weight
        self.types = domainModel.types.map{ $0.mapper() }
    }
    
    func getColorForSpecies(_ speciesName: String) -> Color {
        switch speciesName {
        case "fire":
            return Color("fireColor")
        case "water":
            return Color("waterColor")
        case "grass", "bug" :
            return Color("grassColor")
        default:
            return Color("flyingColor")
        }
    }
}
