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
    var itemType: String = "expense"
    var category: String = ""
    var amount: String = "0"
    
    
    init(name: String, itemType: String, category: String, amount: String, count: Int) {
        self.name = name
        self.itemType = itemType
        self.category = category
        self.amount = amount
    }
    
    
    init() {
        self.name = ""
        self.itemType = ""
        self.category = ""
        self.amount = "0"
    }
    
    
}
