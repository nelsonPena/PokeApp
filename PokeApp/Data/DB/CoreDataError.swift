//
//  CoreDatraError.swift
//  PokeApp
//
//  Created by Nelson Peña on 4/02/24.
//

import Foundation

enum CoreDataError: Error {
    case fetchRequestError
    
    func map() -> DomainError {
        switch self {
        case .fetchRequestError:
            return .generic
        }
    }
}

