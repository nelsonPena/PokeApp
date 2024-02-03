//
//  MockURLSessionHTTPClient.swift
//  RickAndMortyAppTests
//
//  Created by Nelson Geovanny Pena Agudelo on 16/10/23.
//

import Foundation
import Combine
@testable import PokeApp

class MockURLSessionHTTPClient: HttpClient {
    
    
    init() {
    }
    
    func makeRequest<T: Decodable>(endpoint: Endpoint, baseUrl: String) -> AnyPublisher<T, HttpClientError> {
        
        // Simula la obtención de datos del archivo JSON cargado previamente
        guard let mockData = MockData().loadMockData(fromJSONFile: "mock_pokemones", objetType: T.self)else {
             return Fail(error: .generic).eraseToAnyPublisher()
         }
         
         // Crea un publisher que emite los datos simulados
         return Just(mockData)
             .setFailureType(to: HttpClientError.self)
             .eraseToAnyPublisher()
    }
    
    func makeDelete(endpoint: Endpoint, baseUrl: String) -> AnyPublisher<HTTPURLResponse, HttpClientError> {
        
        guard let mockResponse = HTTPURLResponse(
            url: URL(string: "")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )else{
            return Fail(error: .generic).eraseToAnyPublisher()
        }
        return Just(mockResponse)
                .setFailureType(to: HttpClientError.self)
                .eraseToAnyPublisher()
    }
}

