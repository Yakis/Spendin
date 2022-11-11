//
//  ListService.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 01/07/2022.
//

import Foundation
import UIKit
import SwiftSoup

struct FullURL: Codable {
    
    let short: String
    let long: String
}


enum ListService {
    
    private static func session() -> URLSession {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        return URLSession(configuration: config)
    }
    
    static func getList(for id: String) async throws -> ItemList {
        var request = URLRequest(url: .list(id: id))
        let jwt = JWTService.getJWTFromUID()
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        let (data, _) = try await session().data(for: request)
        do {
            let lists = try JSONDecoder().decode([ItemList].self, from: data)
            return lists.first!
        } catch {
            print("Error fetching list: \(error)")
            fatalError()
        }
            
        
    }
    
    
    
    static func getCurrentUser() async throws -> User {
        var request = URLRequest(url: .getCurrentUser())
        let jwt = JWTService.getJWTFromUID()
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        let (data, response) = try await session().data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            print("Error while fetching user: \((response as? HTTPURLResponse).debugDescription)")
            return User(id: "", email: "")
        }
        let user = try JSONDecoder().decode(User.self, from: data)
        return user
    }
    
    
    
    static func getUserLists(ids: [UUID]) async throws -> [ItemList] {
        let jwt = JWTService.getJWTFromUID()
        guard !jwt.isEmpty else { return [] }
        var request = URLRequest(url: .userLists())
        request.httpMethod = "POST"
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let encodedData = try JSONEncoder().encode(["listIDS": ids])
        let (data, response) = try await session().upload(for: request, from: encodedData)
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
    
    
    static func acceptInvitation(for userDetails: UserDetails, to listID: String) async throws -> ItemList {
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
    
    
    static func stopSharing(for userID: String, from listID: String) async throws -> ItemList {
        let jwt = JWTService.getJWTFromUID()
        var request = URLRequest(url: .update(listID: listID))
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        request.httpBody = try JSONEncoder().encode(["id": userID])
        let (data, response) = try await session().data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error while inviting user to list <\(listID)>")
        }
        let updatedList = try JSONDecoder().decode(ItemList.self, from: data)
        return updatedList
    }
    
    
    static func update(user privileges: UserPrivileges, for listID: String) async throws -> ItemList {
        let jwt = JWTService.getJWTFromUID()
        var request = URLRequest(url: .update(listID: listID))
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        request.httpBody = try JSONEncoder().encode(privileges)
        let (data, response) = try await session().data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error while inviting user to list <\(listID)>")
        }
        let updatedList = try JSONDecoder().decode(ItemList.self, from: data)
        return updatedList
    }
    
    
    
    static func shorten(url: String) async throws -> FullURL {
        let jwt = JWTService.getJWTFromUID()
        var request = URLRequest(url: .shorten())
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        request.httpBody = try JSONEncoder().encode(["url": url])
        let (data, response) = try await session().data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error while trying to shorten url: <\(url)>")
        }
        let shortened = try JSONDecoder().decode(FullURL.self, from: data)
        return shortened
    }
    
    
    static func fetchShortened(id: String) async throws -> String {
        let jwt = JWTService.getJWTFromUID()
        var request = URLRequest(url: .fetchShorten(id: id))
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        let (data, response) = try await session().data(for: request)
        do {
            let html: String = String(data: data, encoding: String.Encoding.utf8)!
            let doc: Document = try SwiftSoup.parse(html)
            guard let link: Element = try doc.select("a").first() else { return "Invalid url" }
            let linkHref: String = try link.attr("href")
            return linkHref
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
        }
        return ""
    }
    
    
}
