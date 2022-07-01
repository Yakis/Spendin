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
    
}
