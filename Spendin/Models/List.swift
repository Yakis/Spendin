//
//  List.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 11/11/2021.
//
import Foundation

struct UserDetails: Codable {
    var id: String = ""
    var isOwner: Bool = false
    var readOnly: Bool = true
    var email: String = ""
    var name: String?
    
    init(id: String, isOwner: Bool, readOnly: Bool, email: String, name: String) {
        self.id = id
        self.isOwner = isOwner
        self.readOnly = readOnly
        self.email = email
        self.name = name
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case isOwner, readOnly, email, name
    }
    
}


struct UserPrivileges: Codable {
    var id: String = ""
    var readOnly: Bool = true
    
    init(id: String, readOnly: Bool) {
        self.id = id
        self.readOnly = readOnly
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case readOnly
    }
    
    
}


struct ItemList: Codable {
    
    var id: String
    var name: String
    var createdAt: String
    var users: [UserDetails]
    var itemsCount: Int = 0
    
    init() {
        self.id = ""
        self.name = ""
        self.createdAt = ""
        self.users = []
    }
    
    init(name: String) {
        self.id = ""
        self.name = name
        self.createdAt = ""
        self.users = []
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, createdAt, users, itemsCount
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
