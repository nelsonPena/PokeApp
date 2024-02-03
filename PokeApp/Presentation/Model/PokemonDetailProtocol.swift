//
//  PokemonDetailProtocol.swift
//  PokeApp
//
//  Created by Nelson Peña on 2/02/24.
//

import Foundation

protocol PokemonDetailProtocol {
    var index: Int { get set }
    var abilities: [AbilityPresentableItem]? { get set }
    var name: String { get set }
    var types: [TypeElementPresentableItem]? { get set }
}
