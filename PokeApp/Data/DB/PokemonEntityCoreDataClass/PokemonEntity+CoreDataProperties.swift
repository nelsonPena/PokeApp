//
//  PokemonEntity+CoreDataProperties.swift
//  PokeApp
//
//  Created by Nelson Peña on 4/02/24.
//
//

import Foundation
import CoreData


extension PokemonEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonEntity> {
        return NSFetchRequest<PokemonEntity>(entityName: "PokemonEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var index: Int16
    @NSManaged public var name: String
    @NSManaged public var url: String

}

extension PokemonEntity : Identifiable {

}
