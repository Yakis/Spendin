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
    
    var id: String = UUID().uuidString
    var name: String = ""
    var amount: String = "0"
    var amountLeft: String = "0"
    var category: String = "cart.fill"
    var itemType: String = "expense"
    var due: String = ""
    
    var date: Date {
        return due.isoToDate()
    }
    
    init() {
        self.id = ""
        self.name = ""
        self.amount = "0"
        self.amountLeft = "0"
        self.category = "cart.fill"
        self.itemType = "expense"
        self.due = ""
    }
    
    
    init(id: String, name: String, amount: String, category: String, due: String, itemType: String) {
        self.id = id
        self.name = name
        self.amount = amount
        self.amountLeft = "0"
        self.category = category
        self.due = due
        self.itemType = itemType
    }
    
    
}
