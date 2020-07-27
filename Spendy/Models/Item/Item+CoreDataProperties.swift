//
//  Item+CoreDataProperties.swift
//  Spendy
//
//  Created by Mugurel on 24/07/2020.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var amount: Double
    @NSManaged public var category: String
    @NSManaged public var date: Date
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var type: String

}

extension Item : Identifiable {

}
