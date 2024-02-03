//
//  PokemonDetail.swift
//  PokeApp
//
//  Created by Nelson Peña on 1/02/24.
//

import Foundation

// MARK: - Result
struct PokemonDetail {
    var index: Int = 0
    let abilities: [Ability]
    let height: Int
    let name: String
    let species: Species
    let weight: Int
    let types: [TypeElement]
}

// MARK: - Ability
struct Ability {
    let ability: Species
}

// MARK: - Species
struct Species {
    let name: String
}

struct TypeElement {
    let slot: Int
    let type: Species
}

// MARK: - Mappers
extension PokemonDetail {
    func mapper() -> PokemonDetailPresentableItem {
        .init(domainModel: self)
    }
}

extension Ability {
    func mapper() -> AbilityPresentableItem {
        .init(ability: self.ability.mapper())
    }
}

extension Species {
    func mapper() -> SpeciesPresentableItem {
        .init(name: self.name.capitalized(with: .current))
    }
}

extension TypeElement {
    func mapper() -> TypeElementPresentableItem {
        .init(slot: self.slot, type: self.type.mapper())
    }
}
