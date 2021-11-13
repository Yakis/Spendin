//
//  Schema.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 12/11/2021.
//

import Foundation

import CoreData

/**
 Relevant entities and attributes in the Core Data schema.
 */
enum Schema {
    enum Item: String {
        case name
    }
    enum List: String {
        case id, name
    }
}
