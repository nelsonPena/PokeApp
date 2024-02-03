//
//  AbilitiesEntity+CoreDataProperties.swift
//  PokeApp
//
//  Created by Nelson Peña on 4/02/24.
//
//

import Foundation
import CoreData


extension AbilitiesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AbilitiesEntity> {
        return NSFetchRequest<AbilitiesEntity>(entityName: "AbilitiesEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var detailId: UUID

}

extension AbilitiesEntity : Identifiable {

}

extension AbilitiesEntity {
    func mapToAbility() -> Ability {
        return .init(name: self.name)
    }
}
