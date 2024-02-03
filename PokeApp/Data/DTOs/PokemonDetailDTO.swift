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
    let id: Int
    let name: String
    let order: Int
    let species: SpeciesDTO
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
              species: self.species.mapper(),
              weight: self.weight,
              types: self.types.map { $0.mapper() })
    }
}

extension AbilityDTO {
    // MARK: - Mapping
    /// Mapea un objeto `AbilityDTO` a un objeto `Ability`.
    func mapper() -> Ability {
        .init(ability: self.ability.mapper())
    }
}

extension TypeElementDTO {
    // MARK: - Mapping
    /// Mapea un objeto `TypeElementDTO` a un objeto `TypeElement`.
    func mapper() -> TypeElement {
        .init(slot: self.slot, type: self.type.mapper())
    }
}

extension SpeciesDTO {
    // MARK: - Mapping
    /// Mapea un objeto `SpeciesDTO` a un objeto `Species`.
    func mapper() -> Species {
        .init(name: self.name)
    }
}
