//
//  User.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 08/07/2022.
//

import Foundation

struct User: Codable {
    var id: String
    var name: String?
    var email: String
    var lists: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, email, lists
    }
    
}
