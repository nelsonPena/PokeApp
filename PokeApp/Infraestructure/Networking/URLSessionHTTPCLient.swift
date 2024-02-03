//
//  URLSessionHTTPCLient.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 14/10/23.
//

import Foundation
import Combine

/// `URLSessionHTTPCLient` es una implementación de un cliente HTTP que utiliza la API URLSession de Foundation y Combine para realizar solicitudes HTTP.

class URLSessionHTTPCLient: HttpClient {
    
    private let session: URLSession
    private let requestMaker: UrlSessionRequestMaker
    private let errorResolver: URLSessionErrorResolver
    
    /// Inicializa una nueva instancia de `URLSessionHTTPCLient` con las dependencias necesarias.
    ///
    /// - Parameters:
    ///   - session: Una instancia personalizable de URLSession. Por defecto, se utiliza URLSession.shared.
    ///   - requestMaker: Un creador de solicitudes personalizado.
    ///   - errorResolver: Un resolutor de errores personalizado.
    init(session: URLSession = .shared,
         requestMaker: UrlSessionRequestMaker,
         errorResolver: URLSessionErrorResolver) {
        self.session = session
        self.requestMaker = requestMaker
        self.errorResolver = errorResolver
    }
    
    /// Realiza una solicitud HTTP GET y devuelve una respuesta decodificada de tipo genérico utilizando Combine.
    ///
    /// - Parameters:
    ///   - endpoint: El punto final de la solicitud.
    ///   - baseUrl: La URL base para la solicitud.
    ///
    /// - Returns: Un editor de AnyPublisher que emite una respuesta decodificada de tipo genérico o un error de `HttpClientError`.
    func makeRequest<T: Decodable>(endpoint: Endpoint, baseUrl: String) -> AnyPublisher<T, HttpClientError> {
        
        guard let url = self.requestMaker.url(endpoint: endpoint, baseUrl: baseUrl) else {
            return  Fail(error: .badURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result in
                guard let response = result.response as? HTTPURLResponse else {
                    throw HttpClientError.badURL
                }
                guard response.statusCode == 200 else {
                    throw self.errorResolver.resolve(statusCode: response.statusCode)
                }
                
                return result.data
            }
            .mapError { error in
                if let urLError = error as? URLError, urLError.code == .timedOut {
                    return HttpClientError.timeOut
                } else if let clientError = error as? HttpClientError {
                    return clientError
                } else {
                    return .generic // Handle any other error
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { _ in HttpClientError.generic }
            .eraseToAnyPublisher()
    }
    
    /// Realiza una solicitud HTTP DELETE y devuelve una respuesta de tipo HTTPURLResponse utilizando Combine.
    ///
    /// - Parameters:
    ///   - endpoint: El punto final de la solicitud.
    ///   - baseUrl: La URL base para la solicitud.
    ///
    /// - Returns: Un editor de AnyPublisher que emite una respuesta de tipo HTTPURLResponse o un error de `HttpClientError`.
    func makeDelete(endpoint: Endpoint, baseUrl: String) -> AnyPublisher<HTTPURLResponse, HttpClientError> {
        
        guard let url = self.requestMaker.urlRequest(endpoint: endpoint, baseUrl: baseUrl) else {
            return  Fail(error: .badURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .compactMap { $0.response as? HTTPURLResponse }
            .mapError { error in
                if error.code == .timedOut {
                    return HttpClientError.timeOut
                } else {
                    return .generic // Handle any other error
                }
            }
            .eraseToAnyPublisher()
    }
}
