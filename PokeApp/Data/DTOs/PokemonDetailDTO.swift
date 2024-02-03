//
//  PokemonDetailDTO.swift
//  PokeApp
//
//  Created by Nelson Peña on 1/02/24.
//

import Foundation

// MARK: - Result
struct PokemonDetailDTO: Codable {
    let abilities: [AbilityDTO]
    let height: Int
    let name: String
    let weight: Int
    let types: [TypeElementDTO]
}

// MARK: - Ability
struct AbilityDTO: Codable {
    let ability: SpeciesDTO
}

// MARK: - Species
struct SpeciesDTO: Codable {
    let name: String
}

struct TypeElementDTO: Codable {
    let slot: Int
    let type: SpeciesDTO
}

extension PokemonDetailDTO {
    // MARK: - Mapping
    /// Mapea un objeto `PokemonDetailDTO` a un objeto `PokemonDetail`.
    func mapper() -> PokemonDetail {
        .init(abilities: self.abilities.map { $0.mapper() },
              height: self.height,
              name: self.name,
              weight: self.weight,
              types: self.types.map { $0.mapper() })
    }
}

extension AbilityDTO {
    // MARK: - Mapping
    /// Mapea un objeto `AbilityDTO` a un objeto `Ability`.
    func mapper() -> Ability {
        .init(name: self.ability.name)
    }
}

extension TypeElementDTO {
    // MARK: - Mapping
    /// Mapea un objeto `TypeElementDTO` a un objeto `TypeElement`.
    func mapper() -> TypeElement {
        .init(name: self.type.name)
    }
}
