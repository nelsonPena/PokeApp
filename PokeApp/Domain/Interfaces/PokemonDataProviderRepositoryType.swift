//
//  DataProviderType.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 15/10/23.
//

import Foundation
import Combine

protocol PokemonDataProviderRepositoryType {
    var savedPokemonPublisher: Published<[PokemonEntity]>.Publisher { get }
    func addPokemon(pokemon: [PokemonListPresentableItem])
    func getPokemonDetail(with index: Int) -> AnyPublisher<PokemonDetailEntity?, CoreDataError>
    func getPokemonAbilities(with id: UUID) -> AnyPublisher<[AbilitiesEntity]?, CoreDataError>
    func getPokemonTypeElement(with id: UUID) -> AnyPublisher<[TypeElementEntity]?, CoreDataError>
    func addPokemonDetail(detail pokemonDetail: PokemonDetail) -> UUID
    func addAbilities(detailId: UUID, ability: Ability)
    func addTypeElement(detailId: UUID, element typeElement: TypeElement)
}
