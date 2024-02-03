//
//  GetPokemon.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 14/10/23.
//

import UIKit
import Combine


/// `GetPokemon` es una clase de la capa de dominio que implementa el protocolo `GetPokemonListType` para obtener  los personajes .

class GetPokemon {
    private let repository: PokemonRepositoryType
    
    /// Inicializa una nueva instancia de `GetPokemon` con un repositorio personalizado.
    ///
    /// - Parameters:
    ///   - repository: El repositorio que se utilizará para obtener  los personajes .
    init(repository: PokemonRepositoryType) {
        self.repository = repository
    }
}

extension GetPokemon: GetPokemonListType {
   
    func fetchPokemonDetails(id: Int) -> AnyPublisher<PokemonDetail, DomainError> {
        repository.getPokemonDetail(id: id)
    }
    
    /// Obtiene una lista de los personajes  utilizando el repositorio y emite un editor de AnyPublisher que puede contener una lista de los personajes  o un error de `DomainError`.
    ///
    /// - Returns: Un editor de AnyPublisher que emite una lista de los personajes  o un error de `DomainError`.
    func getPokemons() ->  AnyPublisher<Pokemon, DomainError> {
        repository.getPokemon()
    }
}
