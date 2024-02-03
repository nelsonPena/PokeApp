//
//  PokemonDetailFactory.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 14/10/23.
//

import Foundation
import SwiftUI

/// `PokemonDetailFactory` es una factoría para crear instancias de la vista de detalles de los personajes  (`PokemonDetailView`) junto con su modelo (`PokemonDetailViewModel`).

class PokemonDetailFactory: CreatePokemonListDetailView {
    
    /// Crea y devuelve una instancia de `PokemonDetailView` con los datos de vista proporcionados.
    ///
    /// - Parameters:
    ///   - viewData: Los datos de vista que se utilizarán para configurar la vista de detalles.
    ///
    /// - Returns: Una instancia de `PokemonDetailView`.
    func create(with viewData: PokemonDetailViewData) -> PokemonDetailView {
        return PokemonDetailView(viewModel: createViewModel(viewData: viewData),
                               viewData: viewData)
    }
    
    /// Crea y devuelve una instancia de `PokemonDetailViewModel` con los datos de vista proporcionados.
    ///
    /// - Parameters:
    ///   - viewData: Los datos de vista que se utilizarán para configurar el modelo de detalles.
    ///
    /// - Returns: Una instancia de `PokemonDetailViewModel`.
    private func createViewModel(viewData: PokemonDetailViewData) -> PokemonDetailViewModel {
        return PokemonDetailViewModel(PokemonDetailPresentable: viewData.detail)
    }
    
    /// Crea y devuelve una instancia de `GetPokemonListType` (caso de uso) utilizando un repositorio y fuente de datos específicos.
    ///
    /// - Returns: Una instancia de `GetPokemonListType`.
    private func createUseCase() -> GetPokemonListType {
        return GetPokemon(repository: createRepository())
    }
    
    /// Crea y devuelve una instancia de `PokemonRepositoryType` (repositorio) utilizando una fuente de datos específica.
    ///
    /// - Returns: Una instancia de `PokemonRepositoryType`.
    private func createRepository() -> PokemonRepositoryType {
        return PokemonListRepository(apiDataSource: createDataSource())
    }
    
    /// Crea y devuelve una instancia de `ApiPokemonListDataSourceType` (fuente de datos) utilizando un cliente HTTP específico.
    ///
    /// - Returns: Una instancia de `ApiPokemonListDataSourceType`.
    private func createDataSource() -> ApiPokemonListDataSourceType {
        return APIPokemonListDataSource(httpClient: createHTTPClient())
    }
    
    /// Crea y devuelve una instancia de `HttpClient` (cliente HTTP) utilizando un creador de solicitudes y resolutor de errores específicos.
    ///
    /// - Returns: Una instancia de `HttpClient`.
    private func createHTTPClient() -> HttpClient {
        return URLSessionHTTPCLient(requestMaker: UrlSessionRequestMaker(),
                                    errorResolver: URLSessionErrorResolver())
    }
}
