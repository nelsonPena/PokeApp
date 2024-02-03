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
        
    private let dataProvider: PokemonDataProviderRepositoryType
    private var cancellables = Set<AnyCancellable>()
    
    /// Una matriz de personajes presentados como entidades de la capa de persistencia.
    @Published var pokemons: [PokemonEntity] = []
    
    /// Inicializa una nueva instancia de `DataLayerRepository` con un proveedor de datos de capa de persistencia.
    ///
    /// - Parameters:
    ///   - provider: El proveedor de datos de capa de persistencia que se utilizará para interactuar con los datos de los personajes  a eliminar.
    init(provider: PokemonDataProviderRepositoryType) {
        self.dataProvider = provider
        setup()
    }
    
    // MARK: Private functions
    private func setup() {
        self.dataProvider.savedPokemonPublisher
            .assign(to: \.pokemons, on: self)
            .store(in: &cancellables)
    }
}

extension DataLayerRepository: DataLayerRepositoryType {
    
    var savedPokemon: Published<[PokemonEntity]>.Publisher {
        $pokemons
    }
    
    func addPokemon(pokemon: [PokemonListPresentableItem]) {
        dataProvider.addPokemon(pokemon: pokemon)
    }
    
    func addPokemonDetail(detail pokemonDetail: PokemonDetail) -> UUID {
        dataProvider.addPokemonDetail(detail: pokemonDetail)
    }
    
    func addPokemonAbility(detailId: UUID, ability: Ability)  {
        dataProvider.addAbilities(detailId: detailId, ability: ability)
    }
    
    func addTypeElement(detailId: UUID, element: TypeElement)  {
        dataProvider.addTypeElement(detailId: detailId, element: element)
    }
    
    func getPokemonDetail(with index: Int) -> AnyPublisher<PokemonDetailEntity?, CoreDataError> {
        dataProvider.getPokemonDetail(with: index)
    }
    
    func getPokemonAbilities(with detailId: UUID) -> AnyPublisher<[AbilitiesEntity]?, CoreDataError> {
        dataProvider.getPokemonAbilities(with: detailId)
    }
    
    func getTypeElement(with detailId: UUID) -> AnyPublisher<[TypeElementEntity]?, CoreDataError> {
        dataProvider.getPokemonTypeElement(with: detailId)
    }
}
