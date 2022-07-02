//
//  ListService.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 01/07/2022.
//

import Foundation


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
        let (data, _) = try await session().data(from: .allLists())
        let lists = try JSONDecoder().decode([ItemList].self, from: data)
        return lists
    }
    
    
    static func save(list: ItemList) async throws {
        var request = URLRequest(url: .saveList())
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let encodedList = try JSONEncoder().encode(list)
        let (_, response) = try await session().upload(for: request, from: encodedList)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error while fetching data")
        }
    }
    
    
    static func delete(list: ItemList) async throws {
        var request = URLRequest(url: .delete(listID: list.id))
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let (_, response) = try await session().data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error while deleting list <\(list.id)>")
        }
    }
    
    
}
