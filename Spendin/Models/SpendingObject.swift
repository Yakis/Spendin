//
//  SpendingObject.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 04/11/2021.
//

import Foundation

struct SpendingObject {
    
    var id: String
    var name: String
    var amount: Double
    var category: String
    var date: Date
    var type: ItemType
    
    
    init(id: String, name: String, amount: Double, category: String, date: Date, type: ItemType) {
        self.id = id
        self.name = name
        self.amount = amount
        self.category = category
        self.date = date
        self.type = type
    }
    
    
    init(from item: Item) {
        self.amount = item.amount
        self.category = item.category ?? ""
        self.date = item.date ?? Date()
        self.id = item.id ?? ""
        self.name = item.name ?? ""
        self.type = ItemType(rawValue: item.type!) ?? .expense
    }
    
    
}
