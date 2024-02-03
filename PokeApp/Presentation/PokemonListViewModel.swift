//
//  PokemonListViewModel.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 14/10/23.
//

import UIKit
import Combine


/// ViewModel responsable de gestionar la lógica y los datos de la vista de lista de los personajes .
class PokemonListViewModel: ObservableObject {
    
    /// Tipo que proporciona acceso a las operaciones relacionadas con la obtención y eliminación de los personajes .
    private let GetPokemonListType: GetPokemonListType
    
    /// Mapeador de errores específico de la vista de lista de los personajes .
    private let errorMapper: PokemonPresentableErrorMapper
    
    /// Conjunto de suscripciones a cambios de datos.
    private var cancellables = Set<AnyCancellable>()
    
    /// Conjunto de suscripciones para cambios en la lista de personajes guardados
    @Published var savedPokemon: [SavedPokemon] = []
    
    /// Proveedor de datos para la gestión de los personajes  en la aplicación.
    private let dataProvider: DataProvider
    
    /// Lista de los personajes  que se muestra en la vista.
    @Published var pokemonList: [PokemonListPresentableItem] = []
    
    @Published var pokemonDetail: PokemonDetailPresentableItem?
    
    /// Indica si se debe mostrar el indicador de carga.
    @Published var showLoadingSpinner: Bool = false
    
    /// Mensaje de error que se muestra en caso de problemas.
    @Published var showErrorMessage: String?
    
    /// Mensaje de carga personalizado.
    @Published var loaderMensaje: String = ""
    
    /// Variable de búsqueda por texto
    @Published var searchText = ""
    
    /// Variable de búsqueda por tipo
    @Published var selectedType: PokemonType = .all
    
    var searchResults: [PokemonListPresentableItem] {
        if searchText.isEmpty && selectedType == .all {
            return pokemonList
        } else {
            if !searchText.isEmpty {
                return pokemonList.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            } else {
                return pokemonList.filter {
                    guard let types = $0.getTypes(name: selectedType.value) else {
                        return false
                    }
                    return types.count > 0
                }
            }
        }
    }
    
    /// Inicializa un nuevo ViewModel de lista de los personajes .
    /// - Parameters:
    ///   - GetPokemonListType: Tipo que proporciona acceso a las operaciones de obtención y eliminación de los personajes .
    ///   - dataProvider: Proveedor de datos para la gestión de los personajes  en la aplicación.
    ///   - errorMapper: Mapeador de errores específico de la vista de lista de los personajes .
    init(GetPokemonListType: GetPokemonListType,
         dataProvider: DataProvider,
         errorMapper: PokemonPresentableErrorMapper) {
        self.GetPokemonListType = GetPokemonListType
        self.errorMapper = errorMapper
        self.dataProvider = dataProvider
        setup()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    /// Obtiene el proveedor de datos.
    /// - Returns: Proveedor de datos para la gestión de los personajes .
    func getDataProvider() -> DataProvider {
        dataProvider
    }
    
    /// Configura la vista y carga la lista de los personajes .
    func setup() {
        showLoadingSpinner = true
        showErrorMessage = nil
        loaderMensaje = "loading_records".localized
        loadPokemons()
    }
    
    /// Carga las los personajes  en cache
    func loadPokemons(){
        dataProvider.$pokemon
            .assign(to: \.savedPokemon, on: self)
            .store(in: &cancellables)
        
        guard savedPokemon.count > 0 else {
            getPokemonesInServer()
            return
        }
        self.pokemonList = savedPokemon.map{
            let index = $0.index
            self.fetchDetails(id: index) { response in
                self.updatePokemonDetails(index: index,
                                          response: response)
            }
            return $0.mapper()
        }
        showLoadingSpinner = false
    }
    
    func getPokemonesInServer(){
        GetPokemonListType.getPokemons()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self?.handleError(error: error)
                }
            }, receiveValue: { [weak self] pokemon in
                guard let self = self else { return }
                let pokemonPresentable = pokemon.results.map {
                    let index = $0.index
                    self.fetchDetails(id: index){ response in
                        self.updatePokemonDetails(index: index,
                                                  response: response)
                    }
                    return  PokemonListPresentableItem(domainModel: $0)
                }
                self.pokemonList = pokemonPresentable
                dataProvider.addPokemon(pokemon: pokemonPresentable)
                showLoadingSpinner = false
                
            })
            .store(in: &cancellables)
    }
    
    func fetchDetails(id: Int, completion: @escaping ((PokemonDetailPresentableItem) -> Void)) {
        GetPokemonListType.fetchPokemonDetails(id: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self?.handleError(error: error)
                }
            }, receiveValue: { response in
                var domainModel = response
                domainModel.index = id
                completion(PokemonDetailPresentableItem(domainModel: domainModel))
            })
            .store(in: &cancellables)
    }
    
    func updatePokemonDetails(index: Int, response: PokemonDetailPresentableItem) {
        guard index > 0 && index < pokemonList.count else { return }
        pokemonList[index - 1].types = response.types
        pokemonList[index - 1].abilities = response.abilities
    }
    
    /// Maneja los errores generados durante la obtención o eliminación de los personajes .
    /// - Parameter error: El error que se ha producido.
    private func handleError(error: DomainError?) {
        showLoadingSpinner = false
        showErrorMessage = errorMapper.map(error: error)
    }
}
