//
//  List.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 11/11/2021.
//
import Foundation
import SwiftData


@Model
final class ItemList {
    
    var name: String = ""
    
    var createdAt: String = Date().ISO8601Format()
    
    @Relationship(.cascade)
    var items: [Item]
    
    init() {
        self.name = ""
        self.createdAt = ""
        self.items = []
    }
    
    init(name: String) {
        self.name = name
        self.createdAt = ""
        self.items = []
    }
    
    
    
}
