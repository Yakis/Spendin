//
//  SpendingObject.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 04/11/2021.
//

import Foundation

struct Item: Encodable {
    
    var id: String
    var name: String
    var amount: String
    var amountLeft: String
    var category: String
    var date: Date
    var type: ItemType
    
    init() {
        self.id = UUID().uuidString
        self.name = ""
        self.amount = ""
        self.amountLeft = ""
        self.category = "cart.fill"
        self.date = Date()
        self.type = .expense
    }
    
    
    init(id: String, name: String, amount: String, category: String, date: Date, type: ItemType) {
        self.id = id
        self.name = name
        self.amount = amount
        self.amountLeft = ""
        self.category = category
        self.date = date
        self.type = type
    }
    
    
    init(from item: CDItem) {
        self.amount = String(format: "%.2f", item.amount)
        self.amountLeft = ""
        self.category = item.category ?? ""
        self.date = item.date ?? Date()
        self.id = item.id ?? ""
        self.name = item.name ?? ""
        self.type = ItemType(rawValue: item.type!) ?? .expense
    }
    
    
}
