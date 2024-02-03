//
//  DataLayer.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 15/10/23.
//

import Foundation
import Combine

/// `DataLayerRepository` es un repositorio de capa de datos que gestiona la interacción con los datos de personajes en la capa de persistencia.

class DataLayerRepository {
        
    private let dataProvider: DataProviderRepositoryType
    private var cancellables = Set<AnyCancellable>()
    
    /// Una matriz de personajes presentados como entidades de la capa de persistencia.
    @Published var pokemon: [PokemonEntity] = []
    
    /// Inicializa una nueva instancia de `DataLayerRepository` con un proveedor de datos de capa de persistencia.
    ///
    /// - Parameters:
    ///   - provider: El proveedor de datos de capa de persistencia que se utilizará para interactuar con los datos de los personajes  a eliminar.
    init(provider: DataProviderRepositoryType) {
        self.dataProvider = provider
        setup()
    }
    
    // MARK: Private functions
    private func setup() {
        self.dataProvider.savedPokemonPublisher
            .assign(to: \.pokemon, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: Public functions
    
    /// Agrega listado de personajes en cache.
    ///
    /// - Parameters:
    ///   - pokemon: listado de registros a crear
    func addPokemon(pokemon: [PokemonListPresentableItem]) {
        dataProvider.addPokemon(pokemon: pokemon)
    }
    
    /// Elimina un personajesde la lista de los personajes  a eliminar.
    ///
    /// - Parameters:
    ///   - Pokemon: La entidad de personaje a eliminar que se va a eliminar de la lista.
    func delete(_ pokemon: PokemonEntity) {
        dataProvider.delete(pokemon)
    }
    
    /// Elimina todas los personajes.
    func deleteAllPokemon() {
        dataProvider.deleteAll()
    }
}
