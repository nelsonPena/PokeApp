//
//  Pokemon.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 14/10/23.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let result = try? JSONDecoder().decode(Result.self, from: jsonData)

import Foundation


// MARK: - Result
struct Pokemon {
    let count: Int
    let next: String
    let results: [ResultElement]
}

// MARK: - ResultElement
struct ResultElement {
    let name: String
    let url: String
    var index: Int
}
