//
//  Suggestion.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 06/11/2021.
//

import Foundation
import SwiftData

@Model
final class Suggestion {
    
    var name: String = ""
    var itemType: ItemType = ItemType.expense
    var category: String = "cart.fill"
    var amount: String = ""
    
    
    init(name: String, itemType: ItemType, category: String, amount: String, count: Int) {
        self.name = name
        self.itemType = itemType
        self.category = category
        self.amount = amount
    }
    
    
    init() {
        self.name = ""
        self.itemType = ItemType.expense
        self.category = ""
        self.amount = "0"
    }
    
    
}
