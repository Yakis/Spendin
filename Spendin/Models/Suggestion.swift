//
//  Suggestion.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 06/11/2021.
//

import Foundation

struct Suggestion: Codable, Hashable {
    
    var id: String = ""
    var name: String = ""
    var type: ItemType = .expense
    var category: String = ""
    var amount: Double = 0
    var count: Int = 0
    
    
    init(name: String, type: ItemType, category: String, amount: Double, count: Int) {
        self.name = name
        self.type = type
        self.category = category
        self.amount = amount
        self.count = count
    }
    
    
}
