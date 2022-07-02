//
//  SpendingObject.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 04/11/2021.
//

import Foundation

struct ListID: Codable {
    var id: String = ""
}


struct Item: Codable {
    
    var id: String = ""
    var name: String = ""
    var amount: Double = 0
    var amountLeft: Double = 0
    var category: String = "cart.fill"
    var itemType: ItemType = .expense
    var list: ListID = ListID()
    var due: String = ""
    
    var date: Date {
        return due.isoToDate()
    }
    
    init() {
        self.id = ""
        self.name = ""
        self.amount = 0
        self.amountLeft = 0
        self.category = "cart.fill"
        self.itemType = .expense
        self.list = ListID()
        self.due = ""
    }
    
    
    init(id: String, name: String, amount: Double, category: String, due: String, type: ItemType) {
        self.id = id
        self.name = name
        self.amount = amount
        self.amountLeft = 0
        self.category = category
        self.due = due
        self.itemType = type
        self.list = ListID()
    }
    
    
}


extension Item: Hashable, Equatable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
