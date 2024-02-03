//
//  CoreDataStack.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 15/10/23.
//

import Foundation
import Combine
import CoreData

class CoreDataStack {
    
    private var managedObjectContext: NSManagedObjectContext
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var Pokemon: [PokemonEntity] = []
    
    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
        publish()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    /// Obtiene todas las los personajes almacenadas en CoreData.
    /// - Returns: Un array de objetos PokemonEntity.
    private func allPokemon() -> [PokemonEntity] {
        do {
            let fetchRequest: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
            return try self.managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return []
        }
    }
    
    /// Guarda los cambios realizados en el contexto de CoreData.
    private func save() {
        do {
            try self.managedObjectContext.save()
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
        }
        publish()
    }
    
    /// Publica la lista de los personajes.
    private func publish() {
        Pokemon = allPokemon()
    }
}

/// Extiende CoreDataStack para conformarla al protocolo DataProviderRepositoryType.
extension CoreDataStack: DataProviderRepositoryType {
    
    // MARK: - DataProviderRepositoryType Methods
    
    /// Publicador para la lista de los personajes a eliminar.
    var savedPokemonPublisher: Published<[PokemonEntity]>.Publisher {
        $Pokemon
    }
    
    /// Agrega un nuevo personaje a la lista de los personajes a eliminar.
    /// - Parameter pokemon: listado de personajes a almacenar.
    func addPokemon(pokemon: [PokemonListPresentableItem]) {
        pokemon.forEach { pokemonItem in
            let pokemonEntity = PokemonEntity(context: managedObjectContext)
            pokemonEntity.id = UUID()
            pokemonEntity.name = pokemonItem.name
            pokemonEntity.url = pokemonItem.url
            pokemonEntity.index = Int16(pokemonItem.index)
            save()
        }
    }
    
    /// Elimina un personaje de la lista de los personajes a eliminar.
    /// - Parameter pokemon: El personaje a eliminar.
    func delete(_ pokemon: PokemonEntity) {
        self.managedObjectContext.delete(pokemon)
        save()
    }
    
    /// Elimina todas las los personajes de la lista de los personajes a eliminar.
    func deleteAll() {
        allPokemon().forEach { object in
            managedObjectContext.delete(object)
        }
        save()
    }
}
