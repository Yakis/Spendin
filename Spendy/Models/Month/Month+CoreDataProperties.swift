//
//  Month+CoreDataProperties.swift
//  Spendy
//
//  Created by Mugurel on 24/08/2020.
//
//

import Foundation
import CoreData


extension Month {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Month> {
        return NSFetchRequest<Month>(entityName: "Month")
    }

    @NSManaged public var name: String?
    @NSManaged public var items: Item?

}

extension Month : Identifiable {

}
