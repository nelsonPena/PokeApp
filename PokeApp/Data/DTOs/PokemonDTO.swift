//
//  Pokemon.swift
//  PokeApp
//
//  Created by Nelson Peña on 1/02/24.
//

import Foundation

// MARK: - Result
struct PokemonDTO: Codable {
    let count: Int
    let next: String
    let results: [ResultElementDTO]
}

// MARK: - ResultElement
struct ResultElementDTO: Codable {
    let name: String
    let url: String
}

extension PokemonDTO {
    // MARK: - Mapping
    /// Mapea un objeto `PokemonDTO` a un objeto `Pokemon`.
    func mapper(index: Int) -> Pokemon {
        .init(count: self.count, next: self.next, results: self.results.map { $0.mapper(index: index) })
    }
}

extension ResultElementDTO {
    // MARK: - Mapping
    /// Mapea un objeto `ResultElementDTO` a un objeto `ResultElement`.
    func mapper(index: Int) -> ResultElement {
        .init(name: self.name, url: self.url, index: index)
    }
}
