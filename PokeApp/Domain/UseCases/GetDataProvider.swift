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
    private let model: DataLayerRepositoryType
    private var cancellables = Set<AnyCancellable>()
    @Published var pokemons: [SavedPokemon] = []
    
    init (model: DataLayerRepositoryType) {
        formatter.dateStyle = .medium
        self.model = model
        load()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    /// Carga  los personajes  desde el modelo de capa de datos y las asigna a la propiedad publicada `Pokemon`.
    private func load() {
        self.model.savedPokemon
            .map({ pokemon -> [SavedPokemon] in
                pokemon.map { SavedPokemon(name: $0.name,
                                           url: $0.url,
                                           index: Int($0.index)) }
            })
            .replaceError(with: [])
            .assign(to: \.pokemons, on: self)
            .store(in: &cancellables)
    }
    
    func getPokemonDetail(with index: Int, completion: @escaping ((PokemonDetail?, UUID?) -> Void)){
        model.getPokemonDetail(with: index)
            .receive(on: DispatchQueue.main)
            .mapError { error in
                return (error as? CoreDataError)?.map() ?? .generic
            }.sink(receiveCompletion: { _ in },
                   receiveValue: { pokemonDetailEntity in
                guard let pokemonDetailEntity = pokemonDetailEntity else { 
                    completion(nil, pokemonDetailEntity?.id)
                    return }
                let pokemonDetail =  PokemonDetail(abilities: [],
                                                   height: Int(pokemonDetailEntity.height),
                                                   name: pokemonDetailEntity.name,
                                                   weight: Int(pokemonDetailEntity.height),
                                                   types: [])
                
                
                completion(pokemonDetail, pokemonDetailEntity.id)
            })
            .store(in: &cancellables)
    }
    
    func getElementType(with id: UUID, completion: @escaping (([TypeElement]) -> Void)) {
        model.getTypeElement(with: id)
            .receive(on: DispatchQueue.main)
            .tryMap { response -> [TypeElement] in
                
                guard let typeElementEntities = response else {
                    throw CoreDataError.fetchRequestError
                }
                
                let typeElement = typeElementEntities.map { abilityEntity in
                    return abilityEntity.mapToTypeElement()
                }
                
                return typeElement
            }
            .mapError { error in
                return (error as? CoreDataError)?.map() ?? .generic
            }
            .sink(receiveCompletion: { _ in },
                  receiveValue: { typeElement in
                completion(typeElement)
            })
            .store(in: &cancellables)
    }
    
    func getAbilities(with id: UUID, completion: @escaping (([Ability]) -> Void)) {
        model.getPokemonAbilities(with: id)
            .receive(on: DispatchQueue.main)
            .tryMap { response -> [Ability] in
                
                guard let abilitiesEntities = response else {
                    throw CoreDataError.fetchRequestError
                }
                
                let abilities = abilitiesEntities.map { abilityEntity in
                    return abilityEntity.mapToAbility()
                }
                
                return abilities
            }
            .mapError { error in
                return (error as? CoreDataError)?.map() ?? .generic
            }
            .sink(receiveCompletion: { _ in },
                  receiveValue: { ability in
                completion(ability)
            })
            .store(in: &cancellables)
    }
}

extension DataProvider: DataProviderType {
    
    var savedPokemons: Published<[SavedPokemon]>.Publisher {
        $pokemons
    }
    
    func addPokemon(pokemon: [PokemonListPresentableItem]) {
        model.addPokemon(pokemon: pokemon)
    }
    
    func addDetail(detail pokemonDetail: PokemonDetail) {
        let detailId = model.addPokemonDetail(detail: pokemonDetail)
        pokemonDetail.abilities.forEach {
            model.addPokemonAbility(detailId: detailId, ability: $0)
        }
        pokemonDetail.types.forEach {
            model.addTypeElement(detailId: detailId, element: $0)
        }
    }
    
    func getDetail(with index: Int, completion: @escaping ((PokemonDetail?) -> Void)) {
        
        self.getPokemonDetail(with: index) { result, id in
            guard let result = result else {
                completion(nil)
                return
            }
            
            var types: [TypeElement] = []
            var abilities: [Ability] = []
            
            let group = DispatchGroup()
            
            group.enter()
            self.getAbilities(with: id ?? UUID())  { result in
                abilities = result
                group.leave()
            }
            
            group.enter()
            self.getElementType(with: id ?? UUID()) { result in
                types = result
                group.leave()
            }
            
            // Esperar a que todas las operaciones se completen
            group.notify(queue: .main) {
                completion(PokemonDetail(abilities: abilities,
                                         height: result.height,
                                         name: result.name,
                                         weight: result.weight,
                                         types: types))
                
            }
        }
    }
}
