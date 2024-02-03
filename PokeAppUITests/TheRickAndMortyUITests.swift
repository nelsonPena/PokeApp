//
//  RickAndMortyAppUITests.swift
//
//  Created by Nelson Geovanny Pena Agudelo on 14/10/23.
//

import XCTest

final class PokeAppUITests: XCTestCase {
    
    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    // MARK: - Test Cases
    
    /// Prueba la navegación desde la lista de los personajes  a la vista de detalle.
    func testPokemonListNavigation() {
        let app = XCUIApplication()
        _ = app.tables.element.waitForExistence(timeout: 1)
        app.cells.element(boundBy: 3).tap()
        XCTAssertTrue(app.staticTexts["Detalle"].exists)
    }
    
    /// Prueba seleccionar un personaje desde la vista de detalle.
    func testSelctPokemon() {
        let app = XCUIApplication()
        _ = app.grids.element.waitForExistence(timeout: 1)
        app.cells.element(boundBy: 3).tap()
        
        // Obtiene el valor de la etiqueta en la vista de detalle
        let miValorLabel = app.staticTexts.matching(identifier: "nameLabel").firstMatch
        let valor = miValorLabel.label
        
        // Toca el botón de eliminar
        let doneButton = app.buttons.matching(identifier: "doneButton").firstMatch
        doneButton.tap()
        
        // Verifica que la celda con el mismo valor ya no exista
        let cell = app.tables.cells.containing(.staticText, identifier: valor).element
        XCTAssertFalse(cell.exists)
    }
}
