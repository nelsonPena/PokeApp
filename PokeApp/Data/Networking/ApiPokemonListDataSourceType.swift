//
//  ApiLoginDataSourceType.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 14/10/23.
//

import Foundation
import Combine

protocol ApiPokemonListDataSourceType {
    func GetPokemonList() -> AnyPublisher<PokemonDTO, HttpClientError>
    func GetPokemonDetail(id: Int) -> AnyPublisher<PokemonDetailDTO, HttpClientError>
}
