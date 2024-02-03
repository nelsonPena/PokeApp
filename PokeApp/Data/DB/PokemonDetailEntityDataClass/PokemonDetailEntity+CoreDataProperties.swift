//
//  PokemonDetailEntity+CoreDataProperties.swift
//  PokeApp
//
//  Created by Nelson Peña on 4/02/24.
//
//

import Foundation
import CoreData


extension PokemonDetailEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonDetailEntity> {
        return NSFetchRequest<PokemonDetailEntity>(entityName: "PokemonDetailEntity")
    }

    @NSManaged public var height: Int16
    @NSManaged public var name: String
    @NSManaged public var weight: Int16
    @NSManaged public var id: UUID
    @NSManaged public var index: Int16

}

extension PokemonDetailEntity : Identifiable {

}
