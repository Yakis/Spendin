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
    
    private static var encoder: JSONEncoder {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        return jsonEncoder
    }
    
    private static var decoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }
    
    
    static func getItems(for listID: String) async throws -> [Item] {
        let jwt = JWTService.getJWTFromUID()
        var request = URLRequest(url: .items(for: listID))
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        let (data, _) = try await session().data(for: request)
        let items = try decoder.decode([Item].self, from: data)
        return items
    }
    
    
    static func save(item: Item) async throws {
        let jwt = JWTService.getJWTFromUID()
        var request = URLRequest(url: .saveItem())
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        let itemToUpload = UploadedItem(item: item)
        let encodedItem = try encoder.encode(itemToUpload)
        print(encodedItem.prettyPrintedJSONString)
        let (_, response) = try await session().upload(for: request, from: encodedItem)
//        print(response)
//        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
//            fatalError("Error while fetching data")
//        }
    }
    
    
    static func update(item: Item) async throws {
        let jwt = JWTService.getJWTFromUID()
        var request = URLRequest(url: .update(itemID: item.id))
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        let encodedItem = try encoder.encode(item)
        let (_, response) = try await session().upload(for: request, from: encodedItem)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error while fetching data")
        }
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
