//
//  ItemService.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 01/07/2022.
//

import Foundation

enum ItemService {
    
    private static func session() -> URLSession {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        return URLSession(configuration: config)
    }
    
    static func getItems(for listID: String) async throws -> [Item] {
        let jwt = JWTService.getJWTFromUID()
        var request = URLRequest(url: .items(for: listID))
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        let (data, _) = try await session().data(for: request)
        let items = try JSONDecoder().decode([Item].self, from: data)
        return items
    }
    
    
    static func save(item: Item, listID: String) async throws {
        let jwt = JWTService.getJWTFromUID()
        var request = URLRequest(url: .saveItem(for: listID))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        let encodedItem = try JSONEncoder().encode(item)
        let (_, response) = try await session().upload(for: request, from: encodedItem)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error while fetching data")
        }
    }
    
    
    static func update(item: Item) async throws {
        print("Begin updating item")
        let jwt = JWTService.getJWTFromUID()
        var request = URLRequest(url: .update(itemID: item.id))
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        let encodedItem = try JSONEncoder().encode(item)
        let (_, response) = try await session().upload(for: request, from: encodedItem)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error while fetching data")
        }
        print("Item updated on server")
    }
    
    
    static func delete(item: Item) async throws {
        let jwt = JWTService.getJWTFromUID()
        var request = URLRequest(url: .delete(itemID: item.id))
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        let (_, response) = try await session().data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error while deleting item <\(item.id)>")
        }
    }
    
}
