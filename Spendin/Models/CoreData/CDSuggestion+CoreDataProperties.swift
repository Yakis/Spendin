//
//  CDSuggestion+CoreDataProperties.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 06/11/2021.
//
//

import Foundation
import CoreData


extension CDSuggestion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDSuggestion> {
        return NSFetchRequest<CDSuggestion>(entityName: "CDSuggestion")
    }

    @NSManaged public var name: String?
    @NSManaged public var amount: Double
    @NSManaged public var category: String?
    @NSManaged public var type: String?
    @NSManaged public var count: Int64

}

extension CDSuggestion : Identifiable {

}
