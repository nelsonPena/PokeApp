//
//  PokemonListViewModel.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 14/10/23.
//

import UIKit
import Combine

/// ViewModel responsable de gestionar la lógica y los datos de la vista de lista de los personajes.
class PokemonListViewModel: ObservableObject {
    
    /// Tipo que proporciona acceso a las operaciones relacionadas con la obtención.
    private let getPokemonListType: GetPokemonListType
    
    /// Mapeador de errores específico de la vista de lista de los personajes.
    private let errorMapper: PokemonPresentableErrorMapper
    
    /// Conjunto de suscripciones a cambios de datos.
    private var cancellables = Set<AnyCancellable>()
    
    /// Conjunto de suscripciones para cambios en la lista de personajes guardados.
    @Published var savedPokemon: [SavedPokemon] = []
    
    /// Proveedor de datos para la gestión de los personajes en la aplicación.
    private let dataProvider: DataProvider
    
    /// Lista de los personajes que se muestra en la vista.
    @Published var pokemonList: [PokemonListPresentableItem] = []
    
    @Published var pokemonDetail: PokemonDetailPresentableItem?
    
    /// Indica si se debe mostrar el indicador de carga.
    @Published var showLoadingSpinner: Bool = false
    
    /// Mensaje de error que se muestra en caso de problemas.
    @Published var showErrorMessage: String?
    
    /// Mensaje de carga personalizado.
    @Published var loaderMensaje: String = ""
    
    /// Variable de búsqueda por texto.
    @Published var searchText = ""
    
    /// Variable de búsqueda por tipo.
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
    
    init(getPokemonListType: GetPokemonListType,
         dataProvider: DataProvider,
         errorMapper: PokemonPresentableErrorMapper) {
        self.getPokemonListType = getPokemonListType
        self.errorMapper = errorMapper
        self.dataProvider = dataProvider
        setup()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    /// Obtiene el proveedor de datos.
    /// - Returns: Proveedor de datos para la gestión de los personajes.
    func getDataProvider() -> DataProvider {
        dataProvider
    }
    
    /// Configura la vista y carga la lista de los personajes.
    func setup() {
        showLoadingSpinner = true
        showErrorMessage = nil
        loaderMensaje = "loading_records".localized
        tryLoadLocalData()
    }
    
    func addDetailsMainList(with index: Int) {
        self.fetchDetails(with: index) { response in
            self.updateMainList(index: index,
                                response: response)
            self.savePokemonDetail(detail: response)
        }
    }
    
    func updateMainList(index: Int, response: PokemonDetail) {
        let detailPresentableItem = PokemonDetailPresentableItem(domainModel: response)
        guard index > 0 && index < pokemonList.count else { return }
        pokemonList[index - 1].types = detailPresentableItem.types
        pokemonList[index - 1].abilities = detailPresentableItem.abilities
        pokemonList[index - 1].name = detailPresentableItem.name
    }
    
    /// Maneja los errores generados durante la obtención o eliminación de los personajes.
    /// - Parameter error: El error que se ha producido.
    private func handleError(error: DomainError?) {
        showLoadingSpinner = false
        showErrorMessage = errorMapper.map(error: error)
    }
}

//MARK: Obtener data red

extension PokemonListViewModel {
    
    /// Obtiene los detalles de un Pokémon, primero intenta cargarlos localmente y en caso de no encontrarlos, realiza una solicitud al servidor.
    /// - Parameters:
    ///   - id: Identificador del Pokémon.
    ///   - completion: Manejador de finalización que devuelve el detalle del Pokémon.
    func fetchDetails(with id: Int, completion: @escaping ((PokemonDetail) -> Void)) {
        self.fetchLocalDetails(with: id) { [weak self] response in
            guard let self = self else { return }
            guard let response = response else {
                self.getDetailsInServer(with: id) { pokemonDetail in
                    completion(pokemonDetail)
                }
                return
            }
            
            var domainModel = response
            domainModel.index = id
            completion(domainModel)
        }
    }
    
    /// Realiza una solicitud al servidor para obtener los detalles de un Pokémon.
    /// - Parameters:
    ///   - id: Identificador del Pokémon.
    ///   - completion: Manejador de finalización que devuelve el detalle del Pokémon.
    func getDetailsInServer(with id: Int, completion: @escaping ((PokemonDetail) -> Void)) {
        getPokemonListType.fetchPokemonDetails(id: id)
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
                completion(domainModel)
            })
            .store(in: &cancellables)
    }
    
    /// Obtiene la lista de Pokémon del servidor y actualiza la vista.
    func getPokemonesInServer() {
        getPokemonListType.getPokemons()
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
                    self.addDetailsMainList(with: index)
                    return PokemonListPresentableItem(domainModel: $0)
                }
                self.pokemonList = pokemonPresentable
                self.savePokemons(list: pokemonPresentable)
                self.showLoadingSpinner = false
            })
            .store(in: &cancellables)
    }
}

//MARK: Obtener data local

extension PokemonListViewModel {
    
    /// Intenta cargar datos locales de los Pokémon guardados. Si no hay datos locales, realiza una solicitud al servidor.
    func tryLoadLocalData() {
        dataProvider.savedPokemons
            .assign(to: \.savedPokemon, on: self)
            .store(in: &cancellables)
        
        guard savedPokemon.count > 0 else {
            getPokemonesInServer()
            return
        }
        
        self.pokemonList = savedPokemon.map {
            let index = $0.index
            self.fetchLocalDetails(with: index) { response in
                guard let response = response else { return }
                self.updateMainList(index: index,
                                    response: response)
            }
            return $0.mapper()
        }
        showLoadingSpinner = false
    }
    
    /// Obtiene los detalles locales de un Pokémon.
    /// - Parameters:
    ///   - index: Índice del Pokémon.
    ///   - completion: Manejador de finalización que devuelve los detalles del Pokémon.
    func fetchLocalDetails(with index: Int, completion: @escaping ((PokemonDetail?) -> Void)) {
        self.dataProvider.getDetail(with: index) { pokemonDetail in
            guard let pokemonDetail = pokemonDetail else {
                completion(nil)
                return
            }
            completion(pokemonDetail)
        }
    }
    
    /// Guarda la lista de Pokémon en la base de datos local.
    /// - Parameter pokemonPresentable: Lista de Pokémon presentables.
    func savePokemons(list pokemonPresentable: [PokemonListPresentableItem]) {
        dataProvider.addPokemon(pokemon: pokemonPresentable)
    }
    
    /// Guarda los detalles de un Pokémon en la base de datos local.
    /// - Parameter detail: Detalles del Pokémon.
    func savePokemonDetail(detail pokemonDetail: PokemonDetail) {
        dataProvider.addDetail(detail: pokemonDetail)
    }
}
