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
    let weight: Int
    let types: [TypeElement]
}

// MARK: - Ability
struct Ability {
    let name: String
}

struct TypeElement {
    let name: String
}

// MARK: - Mappers
extension PokemonDetail {
    func mapper() -> PokemonDetailPresentableItem {
        .init(domainModel: self)
    }
}

extension Ability {
    func mapper() -> AbilityPresentableItem {
        .init(name: self.name)
    }
}

extension TypeElement {
    func mapper() -> TypeElementPresentableItem {
        .init(name: self.name)
    }
}
