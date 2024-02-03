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
    case fairy
    case ground
    case fighting
    case rock
    case psychic
    case electric
    case steel
    case ice
    case ghost
    case dragon
    
    init?(name: String) {
        guard let type = PokemonType.allCases.first(where: { $0.name == name }) else {
            return nil
        }
        self = type
    }
    
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
        case .fairy: return "Hada"
        case .ground: return "Suelo"
        case .fighting: return "Lucha"
        case .rock: return "Roca"
        case .psychic: return "Psíquico"
        case .electric: return "Électrico"
        case .steel: return "Acero"
        case .ice: return "Hielo"
        case .ghost: return "Fantasma"
        case .dragon: return "Dragon"
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
        case .fairy: return "fairy"
        case .ground: return "ground"
        case .fighting: return "fighting"
        case .rock: return "rock"
        case .psychic: return "psychic"
        case .electric: return "electric"
        case .steel: return "steel"
        case .ice: return "ice"
        case .ghost: return "ghost"
        case .dragon: return "dragon"
        }
    }
    
    static var sortedCases: [PokemonType] {
        return allCases.sorted { $0.name < $1.name }
    }
}
