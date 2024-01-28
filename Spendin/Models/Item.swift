//
//  SpendingObject.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 04/11/2021.
//

import Foundation
import SwiftData

enum ItemType: String, CaseIterable, Codable {
    case expense
    case income
}

@Model
final class Item {
    
    var name: String = ""
    var amount: String = ""
    var amountLeft: String = ""
    var category: String = "cart.fill"
    var itemType: ItemType = ItemType.expense
    var due: Date = Date()
    
    @Relationship(inverse: \ItemList.items)
    var list: ItemList?
    
    init() {
        self.name = ""
        self.amount = "0"
        self.amountLeft = "0"
        self.category = "cart.fill"
        self.itemType = .expense
        self.due = Date()
    }
    
    
    init(name: String, amount: String, category: String, due: Date, itemType: ItemType) {
        self.name = name
        self.amount = amount
        self.amountLeft = "0"
        self.category = category
        self.due = due
        self.itemType = itemType
    }
    
    
}
