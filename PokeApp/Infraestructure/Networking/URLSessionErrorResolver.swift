//
//  URLSessionErrorResolver.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 15/10/23.
//

import Foundation

class URLSessionErrorResolver {
    func resolve(statusCode: Int) -> HttpClientError {
        guard statusCode != 429 else {
            return .tooManyRequests
        }
        
        guard statusCode >= 500 else {
            return .clientError
        }
        
        return .serverError
    }
    
    func resolve(error: Error) -> HttpClientError {
        return .generic
    }
}
