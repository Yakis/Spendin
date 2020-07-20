//
//  Suggestion+CoreDataProperties.swift
//  Spendy
//
//  Created by Mugurel on 20/07/2020.
//
//

import Foundation
import CoreData


extension Suggestion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Suggestion> {
        return NSFetchRequest<Suggestion>(entityName: "Suggestion")
    }

    @NSManaged public var text: String?
    @NSManaged public var category: String?

}
