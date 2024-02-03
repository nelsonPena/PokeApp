//
//  PokemonDetailViewModel.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 14/10/23.
//

import Foundation
import Combine
import CoreData

/// `PokemonDetailViewModel` es un ViewModel observable que maneja la lógica relacionada con la eliminación de los personajes  y la gestión de la interfaz de usuario para la vista de detalles de los personajes .

class PokemonDetailViewModel: ObservableObject {
    
    /// Una propiedad publicada que indica si se debe mostrar un indicador de carga.
    @Published var showLoadingSpinner: Bool = false
    
    /// Una propiedad publicada que indica si se debe regresar a la vista anterior.
    @Published var goBack: Bool = false
    
    
    /// El objeto `PokemonListPresentableItem` que representa los detalles de el personaje
    let PokemonDetailPresentable: PokemonDetailPresentableItem
    
    private var cancellables = Set<AnyCancellable>()
    
    /// Inicializa una nueva instancia de `PokemonDetailViewModel`.
    ///
    /// - Parameters:
    ///   - GetPokemonListType: Un objeto que implementa `GetPokemonListType` .
    ///   - dataProvider: Un objeto `DataProvider` que gestiona las los personajes en cache.
    ///   - PokemonDetailPresentable: El objeto `PokemonListPresentableItem` que representa los detalles de el personaje.
    ///   - errorMapper: Un mapeador que se utiliza para transformar errores en mensajes de error legibles.
    init(PokemonDetailPresentable: PokemonDetailPresentableItem) {
        self.PokemonDetailPresentable = PokemonDetailPresentable
    }
    
    deinit {
        cancellables.removeAll()
    }
    
}
