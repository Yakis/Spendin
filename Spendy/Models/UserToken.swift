//
//  UserToken.swift
//  Spendy
//
//  Created by Mugurel on 26/07/2020.
//

import Foundation


struct UserToken: Codable {
    var id: UUID
    var user: User
    var value: String
    
}


struct User: Codable {
    var id: UUID
}
