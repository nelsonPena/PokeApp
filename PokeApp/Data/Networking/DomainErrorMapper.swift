//
//  PokemonDomainErrorMapper.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 14/10/23.
//

import Foundation

extension URLError{
    func map() -> DomainError {
        switch self.code {
        case .badURL,
                .badServerResponse:
            return .generic
        case .timedOut:
            return .timeOut
        default:
            return .generic
        }
    }
}
