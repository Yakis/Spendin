//
//  CDItem+CoreDataProperties.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 11/11/2021.
//
//

import Foundation
import CoreData


extension CDItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDItem> {
        return NSFetchRequest<CDItem>(entityName: "CDItem")
    }

    @NSManaged public var amount: Double
    @NSManaged public var category: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var list: CDList?

}

extension CDItem : Identifiable {

}
