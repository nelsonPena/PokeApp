//
//  PokemonRepositoryType.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 14/10/23.
//

import Foundation
import Combine

protocol PokemonRepositoryType {
    func getPokemon() -> AnyPublisher<Pokemon, DomainError>
    func getPokemonDetail(id: Int) -> AnyPublisher<PokemonDetail, DomainError>
}
