//
//  CDList+CoreDataProperties.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 11/11/2021.
//
//

import Foundation
import CoreData


extension CDList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDList> {
        return NSFetchRequest<CDList>(entityName: "CDList")
    }

    @NSManaged public var name: String?
    @NSManaged public var shared: Bool
    @NSManaged public var created: Date?
    @NSManaged public var id: String?
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension CDList {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: CDItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: CDItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension CDList : Identifiable {

}
