//
//  SuggestionService.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 02/07/2022.
//

import Foundation

enum SuggestionService {
    
    private static func session() -> URLSession {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        return URLSession(configuration: config)
    }
    
    static func getSuggestions() async throws -> [Suggestion] {
        let jwt = JWTService.getJWTFromUID()
        var request = URLRequest(url: .allSuggestions())
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, _) = try await session().data(for: request)
        let suggestions = try JSONDecoder().decode([Suggestion].self, from: data)
        return suggestions
    }
    
    
    static func save(suggestion: Suggestion) async throws {
        let jwt = JWTService.getJWTFromUID()
        var request = URLRequest(url: .saveSuggestion())
        request.httpMethod = "POST"
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let encodedSuggestion = try JSONEncoder().encode(suggestion)
        let (_, response) = try await session().upload(for: request, from: encodedSuggestion)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error while fetching data")
        }
    }
    
    
    static func update(suggestion: Suggestion) async throws {
        let jwt = JWTService.getJWTFromUID()
        var request = URLRequest(url: .update(suggestionID: suggestion.id))
        request.httpMethod = "PATCH"
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let encodedSuggestion = try JSONEncoder().encode(suggestion)
        let (_, response) = try await session().upload(for: request, from: encodedSuggestion)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error while fetching data")
        }
    }
    
    
    static func delete(suggestion: Suggestion) async throws {
        let jwt = JWTService.getJWTFromUID()
        var request = URLRequest(url: .delete(suggestionID: suggestion.id))
        request.httpMethod = "DELETE"
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let (_, response) = try await session().data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error while deleting suggestion <\(suggestion.id)>")
        }
    }
    
    
    static func deleteAllSuggestions() async throws {
        let jwt = JWTService.getJWTFromUID()
        var request = URLRequest(url: .deleteSuggestions())
        request.httpMethod = "DELETE"
        request.addValue(jwt, forHTTPHeaderField: "User-Id")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let (_, response) = try await session().data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error while deleting suggestions.")
        }
    }
    
}
