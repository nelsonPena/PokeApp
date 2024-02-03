//
//  DataLayerRepository.swift
//  PokeApp
//
//  Created by Nelson Peña on 4/02/24.
//

import Foundation
import Combine

protocol DataLayerRepositoryType {
    var savedPokemon: Published<[PokemonEntity]>.Publisher { get }
    func addPokemon(pokemon: [PokemonListPresentableItem])
    func addPokemonDetail(detail pokemonDetail: PokemonDetail) -> UUID
    func addPokemonAbility(detailId: UUID, ability: Ability)
    func addTypeElement(detailId: UUID, element: TypeElement)
    func getPokemonDetail(with index: Int) -> AnyPublisher<PokemonDetailEntity?, CoreDataError>
    func getPokemonAbilities(with detailId: UUID) -> AnyPublisher<[AbilitiesEntity]?, CoreDataError>
    func getTypeElement(with detailId: UUID) -> AnyPublisher<[TypeElementEntity]?, CoreDataError>
}
