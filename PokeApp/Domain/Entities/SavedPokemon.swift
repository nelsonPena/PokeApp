//
//  DelectedPokemon.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 15/10/23.
//

import Foundation

struct SavedPokemon {
    let name: String
    let url: String
    let index: Int
}

extension SavedPokemon {
    func mapper() -> PokemonListPresentableItem {
        .init(savedModel: self)
    }
}
