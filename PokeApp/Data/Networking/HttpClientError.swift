//
//  HttpClientError.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 15/10/23.
//

import Foundation

enum HttpClientError: Error {
    case clientError
    case serverError
    case generic
    case parsingError
    case badURL
    case responseError
    case tooManyRequests
    case timeOut
    
    func map() -> DomainError {
        switch self {
        case .clientError,
                .serverError,
                .generic,
                .parsingError,
                .badURL,
                .responseError,
                .tooManyRequests:
            return .badServerResponse
        case .timeOut:
            return .timeOut
        }
    }
}

