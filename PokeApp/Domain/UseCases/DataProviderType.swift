//
//  DataProviderType.swift
//  PokeApp
//
//  Created by Nelson Peña on 4/02/24.
//

import Foundation
import Combine

protocol DataProviderType {
    var savedPokemons: Published<[SavedPokemon]>.Publisher { get }
    func addPokemon(pokemon: [PokemonListPresentableItem])
    func addDetail(detail pokemonDetail: PokemonDetail)
    func getDetail(with index: Int, completion: @escaping ((PokemonDetail?) -> Void)) 
}
