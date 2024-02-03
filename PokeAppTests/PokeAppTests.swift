//
//  RickAndMortyAppTests.swift
//
//  Created by Nelson Geovanny Pena Agudelo on 14/10/23.
//

import XCTest
import Combine
@testable import PokeApp

final class PokeAppTests: XCTestCase {
    
    // MARK: - Test Cases
    
    /// Prueba la obtención de los personajes  a través del caso de uso.
    ///
    /// Esta prueba se encarga de verificar que el caso de uso `GetPokemonList` obtenga los personajes
    /// utilizando un cliente HTTP simulado. Se inyecta el cliente simulado en la fábrica
    /// de casos de uso y se crea una expectativa para evaluar el resultado.
    ///
    /// - Precondiciones:
    ///     - `MockURLSessionHTTPClient` está configurado para devolver una respuesta exitosa.
    ///
    /// - Postcondiciones:
    ///     - Se verifica que la operación asincrónica se completa con éxito.
    ///     - Se verifica que la cantidad de los personajes  obtenidas coincide con la respuesta simulada.
    ///
    func testGetPokemonList() {
        var cancellables = Set<AnyCancellable>()
        
        // Crear una instancia del cliente HTTP simulado (MockURLSessionHTTPClient)
        let mockHTTPClient = MockURLSessionHTTPClient()
        
        // Inyectar el cliente simulado en tu fábrica y crear un caso de uso
        let useCase = PokemonListFactory(httpClient: mockHTTPClient).createUseCase()
        
        // Crear una expectativa para el caso de prueba
        let expectation = XCTestExpectation(description: "Obtener los personajes ")
        
        // Llamar a la operación asincrónica (GetPokemonList)
        useCase.getPokemons()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    // La operación asincrónica se completó con éxito
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Error inesperado: \(error)")
                }
            }, receiveValue: { result in
                // Realizar afirmaciones en los datos recibidos
                XCTAssertEqual(result.results.count, 20)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        // Esperar hasta que se cumpla la expectativa (o hasta que expire el tiempo)
        wait(for: [expectation], timeout: 5)
    }
    
    /// Prueba agregar un nuevo registro al DataProvider.
    func testAddDataProvider() {
        let domainModel = ResultElement(name: "Test", url: "", index: 1)
        let item = PokemonListPresentableItem(domainModel: domainModel)
        
        let dataProvider = PokemonListFactory(httpClient: MockURLSessionHTTPClient())
            .createDataProviderUseCase()
        dataProvider.addPokemon(pokemon: [item])
        XCTAssertGreaterThan(dataProvider.pokemon.count, 0, "Existen registros en la base de datos")
    }
}
