//
//  DelectedPokemon.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 15/10/23.
//

import Foundation
import Combine

/// `DataProvider` es una clase de la capa de dominio que gestiona la lógica relacionada con las los personajes  que se deben  almacenar.

class DataProvider {
    
    private let formatter = DateFormatter()
    private let model: DataLayerRepository
    private var cancellables = Set<AnyCancellable>()
    @Published var pokemon: [SavedPokemon] = []
    

    init (model: DataLayerRepository) {
        formatter.dateStyle = .medium
        self.model = model
        load()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    /// Carga  los personajes  desde el modelo de capa de datos y las asigna a la propiedad publicada `Pokemon`.
    private func load() {
        self.model.$pokemon
            .map({ pokemon -> [SavedPokemon] in
                pokemon.map { SavedPokemon(name: $0.name, 
                                           url: $0.url, 
                                           index: Int($0.index)) }
            })
            .replaceError(with: [])
            .assign(to: \.pokemon, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: Public functions
    
    /// Elimina todas los personajes .
    func deleteAllPokemon() {
        model.deleteAllPokemon()
    }
    
    /// Agrega un nuevo personaje con un identificador específico.
    ///
    /// - Parameters:
    ///   - PokemonId: El identificador de el personaje que se va a agregar.
    func addPokemon(pokemon: [PokemonListPresentableItem]) {
        model.addPokemon(pokemon: pokemon)
    }
    
    /// Elimina un personaje con un identificador UUID específico.
    ///
    /// - Parameters:
    ///   - id: El identificador UUID de el personaje que se va a eliminar.
    func deletePokemon(id: UUID) {
        if let PokemonToDelete = model.pokemon.filter({ id == $0.id }).first {
            model.delete(PokemonToDelete)
        }
    }
}
