//
//  SpendingObject.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 04/11/2021.
//

import Foundation
import SwiftData

@Model
final class Item {
    
    @Attribute(.unique) var id: UUID = UUID()
    var name: String = ""
    var amount: String = ""
    var amountLeft: String = ""
    var category: String = ""
    var itemType: String = ""
    var due: String = ""
    
    @Relationship(inverse: \ItemList.items)
    var list: ItemList?
    
    var date: Date {
        return due.isoToDate()
    }
    
    init() {
        self.name = ""
        self.amount = "0"
        self.amountLeft = "0"
        self.category = "cart.fill"
        self.itemType = "expense"
        self.due = ""
    }
    
    
    init(name: String, amount: String, category: String, due: String, itemType: String) {
        self.name = name
        self.amount = amount
        self.amountLeft = "0"
        self.category = category
        self.due = due
        self.itemType = itemType
    }
    
    
}
