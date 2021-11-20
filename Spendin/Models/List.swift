//
//  List.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 11/11/2021.
//

import Foundation

struct ItemList: Encodable {
    
    var id: String
    var name: String
    var created: Date
    var shared: Bool
    var items: [Item]
    
    init() {
        self.id = UUID().uuidString
        self.name = ""
        self.created = Date()
        self.shared = false
        self.items = []
    }
    
    init(name: String) {
        self.id = UUID().uuidString
        self.name = name
        self.created = Date()
        self.shared = false
        self.items = []
    }
    
    
    init(from list: CDList) {
        self.created = list.created ?? Date()
        self.id = list.id ?? ""
        self.name = list.title ?? ""
        self.shared = list.shared
        self.items = list.itemsArray.map { Item(from: $0) }
    }
    
    
}

extension CDList {
    
    public var itemsArray: [CDItem] {
        let set = items as? Set<CDItem> ?? []
        return set.sorted {
            $0.date! < $1.date!
        }
    }
    
}
