//
//  PokemonListErrorMapper.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 14/10/23.
//

import Foundation

class PokemonPresentableErrorMapper {
    func map(error: DomainError?) -> String {
        guard error == .generic else {
            return "generic_text_error".localized
        }
        return "try_later_text_error".localized
    }
}
