//
//  List.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 11/11/2021.
//

import Foundation

struct ItemList: Codable {
    
    var id: String
    var name: String
    var created: String
    var uid: String
    var itemsCount: Int = 0
    
    init() {
        self.id = UUID().uuidString
        self.name = ""
        self.created = ""
        self.uid = ""
    }
    
    init(name: String) {
        self.id = UUID().uuidString
        self.name = name
        self.created = ""
        self.uid = ""
    }
    
    
}


extension ItemList: Hashable, Equatable {
    static func == (lhs: ItemList, rhs: ItemList) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
