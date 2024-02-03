//
//  PokemonListFactory.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 14/10/23.
//

import Foundation

/// `PokemonListFactory` es una factoría para crear instancias de la vista de lista de los personajes  (`PokemonListView`) junto con su modelo (`PokemonListViewModel`).

class PokemonListFactory {
    private let httpClient: HttpClient
    
    /// Inicializa una nueva instancia de `PokemonListFactory` con un cliente HTTP personalizable. Por defecto, se utiliza `URLSessionHTTPCLient` con un creador de solicitudes y resolutor de errores específicos.
    ///
    /// - Parameters:
    ///   - httpClient: Un cliente HTTP que se utilizará para realizar solicitudes de red.
    init(httpClient: HttpClient = URLSessionHTTPCLient(requestMaker: UrlSessionRequestMaker(),
                                                       errorResolver: URLSessionErrorResolver())) {
        self.httpClient = httpClient
    }
    
    /// Crea y devuelve una instancia de `PokemonListView` junto con su modelo (`PokemonListViewModel`) y una vista de detalle de los personajes  (`PokemonDetailView`).
    ///
    /// - Returns: Una instancia de `PokemonListView`.
    func create() -> PokemonListView {
        return PokemonListView(viewModel: createViewModel(),
                             createPokemonListDetailView: PokemonDetailFactory())
    }
    
    /// Crea y devuelve una instancia de `PokemonListViewModel` con casos de uso, proveedor de datos y mapeador de errores específicos.
    ///
    /// - Returns: Una instancia de `PokemonListViewModel`.
    func createViewModel() -> PokemonListViewModel {
        return PokemonListViewModel(getPokemonListType: createUseCase(),
                                  dataProvider: createDataProviderUseCase(),
                                  errorMapper: PokemonPresentableErrorMapper())
    }
    
    /// Crea y devuelve una instancia de `GetPokemonListType` (caso de uso) utilizando un repositorio específico.
    ///
    /// - Returns: Una instancia de `GetPokemonListType`.
    func createUseCase() -> GetPokemonListType {
        return GetPokemon(repository: createRepository())
    }
    
    /// Crea y devuelve una instancia de `PokemonRepositoryType` (repositorio) utilizando una fuente de datos específica.
    ///
    /// - Returns: Una instancia de `PokemonRepositoryType`.
    func createRepository() -> PokemonRepositoryType {
        return PokemonListRepository(apiDataSource: createDataSource())
    }
    
    /// Crea y devuelve una instancia de `ApiPokemonListDataSourceType` (fuente de datos) utilizando un cliente HTTP personalizable.
    ///
    /// - Returns: Una instancia de `ApiPokemonListDataSourceType`.
    func createDataSource() -> ApiPokemonListDataSourceType {
        return APIPokemonListDataSource(httpClient: httpClient)
    }
}

//MARK: CoreData Factory
extension PokemonListFactory {
    
    /// Crea y devuelve una instancia de `DataProvider` utilizando un repositorio de capa de datos específico.
    ///
    /// - Returns: Una instancia de `DataProvider`.
    func createDataProviderUseCase() -> DataProvider {
        return DataProvider(model: createDataLayerRepository())
    }
    
    /// Crea y devuelve una instancia de `DataLayerRepository` utilizando un proveedor de persistencia específico.
    ///
    /// - Returns: Una instancia de `DataLayerRepository`.
    func createDataLayerRepository() -> DataLayerRepository {
        return DataLayerRepository(provider: createPersistence())
    }
    
    /// Crea y devuelve una instancia de `CoreDataStack` utilizando el contexto compartido de la pila de persistencia.
    ///
    /// - Returns: Una instancia de `CoreDataStack`.
    func createPersistence() -> PokemonCoreDataStack {
        return PokemonCoreDataStack(context: PersistenceController.shared.container.viewContext)
    }
}
