//
//  SpendingObject.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 04/11/2021.
//

import Foundation

//struct ListID: Codable {
//    var id: String = ""
//}


struct Item: Codable {
    
    var id: String = ""
    var name: String = ""
    var amount: Double = 0
    var amountLeft: Double = 0
    var category: String = "cart.fill"
    var itemType: ItemType = .expense
    var listId: String = ""
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
        self.listId = ""
        self.due = ""
    }
    
    
    init(id: String, name: String, amount: Double, category: String, due: String, itemType: ItemType, listId: String) {
        self.id = id
        self.name = name
        self.amount = amount
        self.amountLeft = 0
        self.category = category
        self.due = due
        self.itemType = itemType
        self.listId = listId
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, amount, amountLeft, category, due, itemType, listId
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

struct UploadedItem: Encodable {


    var name: String = ""
    var amount: Double = 0
    var amountLeft: Double = 0
    var category: String = "cart.fill"
    var itemType: ItemType = .expense
    var listId: String = ""
    var due: String = ""


    init(item: Item) {
        self.name = item.name
        self.amount = item.amount
        self.amountLeft = 0
        self.category = item.category
        self.due = item.due
        self.itemType = item.itemType
        self.listId = item.listId
    }

}
