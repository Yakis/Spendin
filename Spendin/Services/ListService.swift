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
    
    let shortUrl: String
    let longUrl: String
}


enum ListService {
    
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
        jsonDecoder.dateDecodingStrategy = .iso8601
        return jsonDecoder
    }
    
    static func getList(for id: String) async throws -> ItemList? {
        var request = URLRequest(url: .list(id: id))
        let jwt = JWTService.getJWTFromUID()
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        let (data, _) = try await session().data(for: request)
        do {
            let lists = try decoder.decode([ItemList].self, from: data)
            return lists.first!
        } catch {
            print("Error fetching list: \(error)")
            return nil
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
        let user = try decoder.decode(User.self, from: data)
        return user
    }
    
    
    
    static func getUserLists() async throws -> [ItemList] {
        let jwt = JWTService.getJWTFromUID()
        guard !jwt.isEmpty else { return [] }
        var request = URLRequest(url: .userLists())
        request.httpMethod = "GET"
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, response) = try await session().data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            print("Error while fetching lists: \((response as? HTTPURLResponse).debugDescription)")
            return []
        }
        do {
            let lists = try decoder.decode([ItemList].self, from: data)
            return lists
        } catch {
            print("Error decoding lists: \(error)")
        }
        return []
    }
    
    
    static func save(list: ItemList) async throws {
        let jwt = JWTService.getJWTFromUID()
        var request = URLRequest(url: .saveList())
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        let encodedList = try encoder.encode(["name": list.name])
        let (_, _) = try await session().upload(for: request, from: encodedList)
    }
    
    
    static func delete(list: ItemList) async throws {
        let jwt = JWTService.getJWTFromUID()
        var request = URLRequest(url: .delete(listID: list.id))
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        let (_, _) = try await session().data(for: request)
    }
    
    
    static func update(_ listName: String, for listID: String) async throws -> ItemList {
        let jwt = JWTService.getJWTFromUID()
        var request = URLRequest(url: .update(name: listName, listID: listID))
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        request.httpBody = try encoder.encode(["name": listName])
        let (data, _) = try await session().data(for: request)
        let updatedList = try decoder.decode(ItemList.self, from: data)
        return updatedList
    }
    
    
    static func acceptInvitation(for userDetails: UserDetails, to listID: String) async throws -> ItemList {
        let jwt = JWTService.getJWTFromUID()
        var request = URLRequest(url: .invite(listID: listID))
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        request.httpBody = try encoder.encode(userDetails)
        let (data, _) = try await session().data(for: request)
        return try decoder.decode(ItemList.self, from: data)
    }
    
    
    static func stopSharing(for userID: String, from listID: String) async throws -> ItemList {
        let jwt = JWTService.getJWTFromUID()
        var request = URLRequest(url: .stop(listID: listID))
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        request.httpBody = try encoder.encode(["id": userID])
        let (data, _) = try await session().data(for: request)
        let updatedList = try decoder.decode(ItemList.self, from: data)
        return updatedList
    }
    
    
    static func update(privileges: UserPrivileges, listID: String) async throws -> ItemList {
        let jwt = JWTService.getJWTFromUID()
        var request = URLRequest(url: .privileges(listID: listID))
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        request.httpBody = try encoder.encode(privileges)
        let (data, _) = try await session().data(for: request)
        let updatedList = try decoder.decode(ItemList.self, from: data)
        return updatedList
    }
    
    
    static func shorten(url: String) async throws -> FullURL {
        let jwt = JWTService.getJWTFromUID()
        var request = URLRequest(url: .shorten())
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        request.httpBody = try encoder.encode(["url": url])
        let (data, _) = try await session().data(for: request)
        let shortened = try decoder.decode(FullURL.self, from: data)
        return shortened
    }
    
    
    static func fetchShortened(id: String) async throws -> String {
        let jwt = JWTService.getJWTFromUID()
        var request = URLRequest(url: .fetchShorten(id: id))
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        let (data, _) = try await session().data(for: request)
        do {
            let html: String = String(data: data, encoding: String.Encoding.utf8)!
            let doc: Document = try SwiftSoup.parse(html)
            guard let link: Element = try doc.select("a").first() else { return "Invalid url" }
            let linkHref: String = try link.attr("href")
            return linkHref
        } catch {
            print(error)
        }
        return ""
    }
    
    
}
