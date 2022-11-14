//
//  List.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 11/11/2021.
//

struct UserDetails: Codable {
    var id: String = ""
    var isOwner: Bool = false
    var readOnly: Bool = true
    var email: String = ""
    var name: String?
    
    init(id: String, isOwner: Bool, readOnly: Bool, email: String) {
        self.id = id
        self.isOwner = isOwner
        self.readOnly = readOnly
        self.email = email
    }
    
}


struct UserPrivileges: Codable {
    var id: String = ""
    var readOnly: Bool = true
    
    init(id: String, readOnly: Bool) {
        self.id = id
        self.readOnly = readOnly
    }
    
}


import Foundation

struct ItemList: Codable {
    
    var id: String
    var name: String
    var created: String
    var users: [UserDetails]
    var itemsCount: Int = 0
    
    init() {
        self.id = UUID().uuidString
        self.name = ""
        self.created = ""
        self.users = []
    }
    
    init(name: String) {
        self.id = UUID().uuidString
        self.name = name
        self.created = ""
        self.users = []
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
