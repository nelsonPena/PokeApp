//
//  DataProviderType.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 15/10/23.
//

import Foundation
import Combine

protocol DataProviderRepositoryType {
    var savedPokemonPublisher: Published<[PokemonEntity]>.Publisher { get }
    func addPokemon(pokemon: [PokemonListPresentableItem]) 
    func delete(_ PokemonToDelete: PokemonEntity)
    func deleteAll()
}
