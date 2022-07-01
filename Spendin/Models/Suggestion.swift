//
//  Suggestion.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 06/11/2021.
//

import Foundation

struct Suggestion {
    
    var id: UUID = UUID()
    var name: String = ""
    var type: String = ""
    var category: String = ""
    var amount: Double = 0
    var count: Int64 = 0
    
    
    init(name: String, type: String, category: String, amount: Double, count: Int64) {
        self.name = name
        self.type = type
        self.category = category
        self.amount = amount
        self.count = count
    }
    
    
}
