//
//  APIPokemonListDataSource.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 14/10/23.
//

import Foundation
import Combine

class APIPokemonListDataSource: ApiPokemonListDataSourceType {
    private let httpClient: HttpClient
    
    init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }
    
    func GetPokemonList() -> AnyPublisher<PokemonDTO, HttpClientError> {
        let endpoint = Endpoint(path: "pokemon",
                                queryParameters: ["offset":"151",
                                                  "limit":"151"],
                                method: .get)
        return httpClient.makeRequest(endpoint: endpoint, baseUrl: Bundle.main.infoDictionary?["BaseUrl"] as? String ?? "")
    }
    
    func GetPokemonDetail(id: Int) -> AnyPublisher<PokemonDetailDTO, HttpClientError> {
        let path = String(format: "pokemon/%@/", id.description)
        let endpoint = Endpoint(path: path,
                                queryParameters: ["":""],
                                method: .get)
        return httpClient.makeRequest(endpoint: endpoint, baseUrl: Bundle.main.infoDictionary?["BaseUrl"] as? String ?? "")
    }
}
