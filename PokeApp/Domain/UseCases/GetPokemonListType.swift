//
//  GetPokemonListType.swift
//  PokeApp
//
//  Created by Nelson Peña on 2/02/24.
//

import Foundation
import Combine

/// `GetPokemonListType` es un protocolo de la capa de dominio que define métodos para obtener los personajes.

protocol GetPokemonListType: AnyObject {
    
    /// Obtiene una lista de los personajes y emite un editor de AnyPublisher que puede contener una lista de los personajes o un error de `DomainError`.
    func getPokemons() -> AnyPublisher<Pokemon, DomainError>
    
    /// Obtiene detalles de un personaje específico y emite un editor de AnyPublisher que puede contener los detalles o un error de `DomainError`.
    func fetchPokemonDetails(id: Int) -> AnyPublisher<PokemonDetail, DomainError>
}
