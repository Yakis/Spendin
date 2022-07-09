//
//  ListService.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 01/07/2022.
//

import Foundation
import UIKit

enum ListService {
    
    private static func session() -> URLSession {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        return URLSession(configuration: config)
    }
    
    static func getList(for id: String) async throws -> ItemList {
        let (data, _) = try await session().data(from: .list(id: id))
        let list = try JSONDecoder().decode(ItemList.self, from: data)
        return list
    }
    
    
    static func getAllLists() async throws -> [ItemList] {
        let jwt = JWTService.getJWTFromUID()
        print("======================================")
        print(jwt)
        print("======================================")
        var request = URLRequest(url: .allLists())
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        let (data, response) = try await session().data(for: request)
        let lists = try JSONDecoder().decode([ItemList].self, from: data)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error while fetching data")
        }
        return lists
    }
    
    
    static func save(list: ItemList) async throws {
        let jwt = JWTService.getJWTFromUID()
        var request = URLRequest(url: .saveList())
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        let encodedList = try JSONEncoder().encode(list)
        let (_, response) = try await session().upload(for: request, from: encodedList)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error while fetching data")
        }
    }
    
    
    static func delete(list: ItemList) async throws {
        let jwt = JWTService.getJWTFromUID()
        var request = URLRequest(url: .delete(listID: list.id))
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        let (_, response) = try await session().data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error while deleting list <\(list.id)>")
        }
    }
    
    
    static func update(_ listName: String, for listID: String) async throws -> ItemList {
        let jwt = JWTService.getJWTFromUID()
        var request = URLRequest(url: .update(listID: listID))
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        request.httpBody = try JSONEncoder().encode(["name": listName])
        let (data, response) = try await session().data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error while updating list <\(listName)>")
        }
        let updatedList = try JSONDecoder().decode(ItemList.self, from: data)
        return updatedList
    }
    
    
    static func invite(user userDetails: UserDetails, to listID: String) async throws -> ItemList {
        let jwt = JWTService.getJWTFromUID()
        var request = URLRequest(url: .update(listID: listID))
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        request.httpBody = try JSONEncoder().encode(userDetails)
        let (data, response) = try await session().data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error while inviting user to list <\(listID)>")
        }
        let updatedList = try JSONDecoder().decode(ItemList.self, from: data)
        return updatedList
    }
    
    
}
