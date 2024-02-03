//
//  PokemonType.swift
//  PokeApp
//
//  Created by Nelson Peña on 2/02/24.
//

import Foundation

enum PokemonType: CaseIterable {
    case fire
    case water
    case flying
    case bug
    case grass
    case normal
    case all
    case poison
    
    var name: String {
        switch self {
        case .fire: return "Fuego"
        case .water: return "Agua"
        case .flying: return "Volador"
        case .bug: return "Insecto"
        case .grass: return "Vegetal"
        case .normal: return "Normal"
        case .all: return "Todos"
        case .poison: return "Veneno"
        }
    }
    
    var value: String {
        switch self {
        case .fire: return "fire"
        case .water: return "water"
        case .flying: return "flying"
        case .bug: return "bug"
        case .grass: return "grass"
        case .normal: return "normal"
        case .all: return "all"
        case .poison: return "poison"
        }
    }
    
    static var sortedCases: [PokemonType] {
        return allCases.sorted { $0.name < $1.name }
    }
}
