//
//  Endpoint.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 14/10/23.
//

import Foundation

struct Endpoint {
    let path: String
    let queryParameters: [String: Any]
    let method: HTTPMethod
}

