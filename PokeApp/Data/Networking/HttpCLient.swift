//
//  HttpCLient.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 14/10/23.
//

import Foundation
import Combine

protocol HttpClient {
    func makeRequest<T: Decodable>(endpoint: Endpoint, baseUrl: String) -> AnyPublisher<T, HttpClientError>
    func makeDelete(endpoint: Endpoint, baseUrl: String) -> AnyPublisher<HTTPURLResponse, HttpClientError> 
}
