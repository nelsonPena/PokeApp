//
//  PokemonListRepository.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 14/10/23.
//

import Foundation
import Combine

/// `PokemonListRepository` es un repositorio que gestiona la obtención y eliminación de los personajes utilizando un origen de datos de API.

class PokemonListRepository: PokemonRepositoryType {
    
    private let apiDataSource: ApiPokemonListDataSourceType
    
    /// Inicializa una nueva instancia de `PokemonListRepository` con un origen de datos de API personalizado.
    ///
    /// - Parameter apiDataSource: El origen de datos de API que se utilizará para obtener los personajes.
    init(apiDataSource: ApiPokemonListDataSourceType) {
        self.apiDataSource = apiDataSource
    }
    
    /// Obtiene una lista de los personajes y las mapea a objetos `Pokemon` utilizando Combine.
    ///
    /// - Returns: Un editor de AnyPublisher que emite una lista de los personajes o un error de `DomainError`.
    func getPokemon() -> AnyPublisher<Pokemon, DomainError> {
        let response: AnyPublisher<PokemonDTO, HttpClientError> = apiDataSource.GetPokemonList()
        return response
            .map { pokemonDTO in
                // Mapea cada elemento en la lista de resultados a un objeto Pokemon
                let results = pokemonDTO.results.enumerated().map { (index, resultElementDTO) in
                    resultElementDTO.mapper(index: index + 1)
                }
                return Pokemon(count: pokemonDTO.count, next: pokemonDTO.next, results: results)
            }
            .mapError { $0.map() }
            .eraseToAnyPublisher()
    }
    
    /// Obtiene detalles de un personaje específico utilizando su identificación.
    ///
    /// - Parameter id: La identificación única del personaje.
    /// - Returns: Un editor de AnyPublisher que emite los detalles del personaje o un error de `DomainError`.
    func getPokemonDetail(id: Int) -> AnyPublisher<PokemonDetail, DomainError> {
        let response: AnyPublisher<PokemonDetailDTO, HttpClientError> = apiDataSource.GetPokemonDetail(id: id)
        return response
            .map { $0.mapper() }
            .mapError { $0.map() }
            .eraseToAnyPublisher()
    }
}
