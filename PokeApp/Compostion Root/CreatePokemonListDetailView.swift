//
//  CreatePokemonListDetailView.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 14/10/23.
//

import Foundation
import SwiftUI

/// `CreatePokemonListDetailView` es un protocolo que define un método para crear una vista de detalles de los personajes  (`PokemonDetailView`) utilizando los datos de vista proporcionados.

protocol CreatePokemonListDetailView {
    
    /// Crea y devuelve una instancia de `PokemonDetailView` utilizando los datos de vista proporcionados.
    ///
    /// - Parameters:
    ///   - viewData: Los datos de vista que se utilizarán para configurar la vista de detalles.
    ///
    /// - Returns: Una instancia de `PokemonDetailView`.
    func create(with viewData: PokemonDetailViewData) -> PokemonDetailView
}
