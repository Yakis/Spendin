//
//  Item.swift
//  Spendy
//
//  Created by Mugurel on 30/10/2020.
//

import Foundation
import Firebase

struct Item: Codable, Hashable {
    
    var id: String
    var amount: Double
    var category: String
    var date: Date
    var name: String
    var type: String
    
    init(id: String, amount: Double, category: String, date: Date, name: String, type: String) {
        self.id = id
        self.amount = amount
        self.category = category
        self.date = date
        self.name = name
        self.type = type
    }
    
    init(with document: QueryDocumentSnapshot) {
        let data = document.data()
        self.id = document.documentID
        self.amount = data["amount"] as? Double ?? 0
        self.category = data["category"] as? String ?? ""
        self.date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
        self.name = data["name"] as? String ?? ""
        self.type = data["type"] as? String ?? ""
    }
    
}
