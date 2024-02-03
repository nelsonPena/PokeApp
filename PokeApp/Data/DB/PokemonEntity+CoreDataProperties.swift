//
//  DeletePokemon.swift
//  PokeApp
//
//  Created by Nelson Geovanny Pena Agudelo on 15/10/23.
//

import Foundation
import CoreData

extension PokemonEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonEntity> {
        return NSFetchRequest<PokemonEntity>(entityName: "PokemonEntity")
    }
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var url: String
    @NSManaged public var index: Int16
}
