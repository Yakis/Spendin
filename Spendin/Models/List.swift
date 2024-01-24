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
    
    @Attribute(.unique) var id: UUID = UUID()
    var name: String = ""
    var createdAt: String = Date().ISO8601Format()
    var items: [Item]? = []
    
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
