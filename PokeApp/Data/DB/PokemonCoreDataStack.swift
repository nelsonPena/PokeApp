//
//  CoreDataStack.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 15/10/23.
//

import Foundation
import Combine
import CoreData

class PokemonCoreDataStack {
    
    private var managedObjectContext: NSManagedObjectContext
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var allPokemons: [PokemonEntity] = []
    @Published var abilitiesEntity: [AbilitiesEntity] = []
    @Published var typeElementEntity: [TypeElementEntity] = []
    
    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
        publish()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    /// Obtiene todas las los personajes almacenadas en CoreData.
    /// - Returns: Un array de objetos PokemonEntity.
    private func getAllPokemon() -> [PokemonEntity] {
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
        allPokemons = getAllPokemon()
    }
}

// MARK: - DataProviderRepositoryType Methods

/// Extiende CoreDataStack para conformarla al protocolo DataProviderRepositoryType.
extension PokemonCoreDataStack: PokemonDataProviderRepositoryType {
    
    
    
    /// Publicador para la lista de los personajes a eliminar.
    var savedPokemonPublisher: Published<[PokemonEntity]>.Publisher {
        $allPokemons
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
}
// MARK: - DataProviderRepositoryType Methods

extension PokemonCoreDataStack {
    
    /// Obtiene los detalles de un Pokémon almacenados localmente en CoreData.
    /// - Parameter index: Índice del Pokémon.
    /// - Returns: Publicador que emite el detalle del Pokémon o un error CoreDataError.
    func getPokemonDetail(with index: Int) -> AnyPublisher<PokemonDetailEntity?, CoreDataError> {
        
        let fetchRequest: NSFetchRequest<PokemonDetailEntity> = PokemonDetailEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "index == %d", index as CVarArg)
        
        return Future<PokemonDetailEntity?, CoreDataError> { promise in
            do {
                guard let pokemonDetailEntity = try self.managedObjectContext.fetch(fetchRequest).first else {
                    promise(.success(nil))
                    return
                }
                promise(.success(pokemonDetailEntity))
            } catch {
                promise(.failure(.fetchRequestError))
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Obtiene las habilidades de un Pokémon almacenadas localmente en CoreData.
    /// - Parameter id: Identificador del Pokémon.
    /// - Returns: Publicador que emite la lista de habilidades o un error CoreDataError.
    func getPokemonAbilities(with id: UUID) -> AnyPublisher<[AbilitiesEntity]?, CoreDataError> {
        let fetchRequest: NSFetchRequest<AbilitiesEntity> = AbilitiesEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "detailId == %@", id as CVarArg)
        
        return Future<[AbilitiesEntity]?, CoreDataError> { promise in
            do {
                let abilitiesEntities = try self.managedObjectContext.fetch(fetchRequest)
                promise(.success(abilitiesEntities))
            } catch {
                promise(.failure(.fetchRequestError))
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Obtiene los elementos de tipo de un Pokémon almacenados localmente en CoreData.
    /// - Parameter id: Identificador del Pokémon.
    /// - Returns: Publicador que emite la lista de elementos de tipo o un error CoreDataError.
    func getPokemonTypeElement(with id: UUID) -> AnyPublisher<[TypeElementEntity]?, CoreDataError> {
        
        let fetchRequest: NSFetchRequest<TypeElementEntity> = TypeElementEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "detailId == %@", id as CVarArg)
        
        return Future<[TypeElementEntity]?, CoreDataError> { promise in
            do {
                let typeElementEntities = try self.managedObjectContext.fetch(fetchRequest)
                promise(.success(typeElementEntities))
            } catch {
                promise(.failure(.fetchRequestError))
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Agrega los detalles de un Pokémon a CoreData.
    /// - Parameter detail: Detalles del Pokémon.
    /// - Returns: Identificador único del detalle agregado.
    func addPokemonDetail(detail pokemonDetail: PokemonDetail) -> UUID {
        let id = UUID()
        let pokemonDetailEntity = PokemonDetailEntity(context: managedObjectContext)
        pokemonDetailEntity.height = Int16(pokemonDetail.height)
        pokemonDetailEntity.name = pokemonDetail.name
        pokemonDetailEntity.weight = Int16(pokemonDetail.weight)
        pokemonDetailEntity.id = id
        pokemonDetailEntity.index = Int16(pokemonDetail.index)
        
        save()
        return id
    }
    
    /// Agrega una habilidad de un Pokémon a CoreData.
    /// - Parameters:
    ///   - detailId: Identificador único del detalle del Pokémon.
    ///   - ability: Habilidad del Pokémon.
    func addAbilities(detailId: UUID, ability: Ability) {
        let pokemonDetailEntity = AbilitiesEntity(context: managedObjectContext)
        pokemonDetailEntity.id = UUID()
        pokemonDetailEntity.name = ability.name
        pokemonDetailEntity.detailId = detailId
        
        save()
    }
    
    /// Agrega un elemento de tipo de un Pokémon a CoreData.
    /// - Parameters:
    ///   - detailId: Identificador único del detalle del Pokémon.
    ///   - typeElement: Elemento de tipo del Pokémon.
    func addTypeElement(detailId: UUID, element typeElement: TypeElement) {
        let pokemonDetailEntity = TypeElementEntity(context: managedObjectContext)
        pokemonDetailEntity.id = UUID()
        pokemonDetailEntity.name = typeElement.name
        pokemonDetailEntity.detailId = detailId
        
        save()
    }
    
}
