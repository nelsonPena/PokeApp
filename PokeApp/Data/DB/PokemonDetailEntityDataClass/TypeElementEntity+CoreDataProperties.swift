//
//  TypeElementEntity+CoreDataProperties.swift
//  PokeApp
//
//  Created by Nelson Peña on 4/02/24.
//
//

import Foundation
import CoreData


extension TypeElementEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TypeElementEntity> {
        return NSFetchRequest<TypeElementEntity>(entityName: "TypeElementEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var detailId: UUID
    @NSManaged public var name: String

}

extension TypeElementEntity : Identifiable {

}

extension TypeElementEntity {
    func mapToTypeElement() -> TypeElement {
        return .init(name: self.name)
    }
}
