//
//  URLS.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 01/07/2022.
//

import Foundation


enum ServerEnv {
    case development
    case production
    
    var url: String {
        switch self {
        case .development:
            return "https://3de9-2a00-23c7-602f-e101-ac13-1fb1-8a3e-a53d.eu.ngrok.io/"
        case .production:
            return "https://yakis.cloud/"
        }
    }
    
}


import Foundation


//MARK: - Urls

fileprivate struct URLS {

    static let env: ServerEnv = .development
    
}


extension URL {
    
    
    //MARK: Suggestions
    static func allSuggestions() -> URL {
        return URL(string: "\(URLS.env.url)suggestions")!
    }
    
    static func saveSuggestion() -> URL {
        return URL(string: "\(URLS.env.url)suggestions")!
    }
    
    static func update(suggestionID: String) -> URL {
        let percentEncodedID = suggestionID.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? suggestionID
        return URL(string: "\(URLS.env.url)suggestions/\(percentEncodedID)")!
    }
    
    static func delete(suggestionID: String) -> URL {
        let percentEncodedID = suggestionID.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? suggestionID
        return URL(string: "\(URLS.env.url)suggestions/\(percentEncodedID)")!
    }
    
    static func deleteSuggestions() -> URL {
        return URL(string: "\(URLS.env.url)suggestions")!
    }
    
    
    //MARK: Lists
    static func list(id: String) -> URL {
        return URL(string: "\(URLS.env.url)lists/\(id)")!
    }
    
    static func userLists() -> URL {
        return URL(string: "\(URLS.env.url)lists/user")!
    }
    
    static func saveList() -> URL {
        return URL(string: "\(URLS.env.url)lists")!
    }
    
    static func delete(listID: String) -> URL {
        let percentEncodedID = listID.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? listID
        return URL(string: "\(URLS.env.url)lists/\(percentEncodedID)")!
    }
    
    static func update(listID: String) -> URL {
        let percentEncodedID = listID.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? listID
        return URL(string: "\(URLS.env.url)lists/\(percentEncodedID)")!
    }
    
    
    // MARK: Shorten url
    static func shorten() -> URL {
        return URL(string: "\(URLS.env.url)urls")!
    }
    
    static func fetchShorten(id: String) -> URL {
        let percentEncodedID = id.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? id
        return URL(string: "\(URLS.env.url)urls/\(percentEncodedID)")!
    }
    
    
    //MARK: Items
    static func items(for listID: String) -> URL {
        let percentEncodedID = listID.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? listID
        return URL(string: "\(URLS.env.url)items/\(percentEncodedID)")!
    }
    
    static func saveItem(for listID: String) -> URL {
        let percentEncodedID = listID.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? listID
        return URL(string: "\(URLS.env.url)items/\(percentEncodedID)")!
    }
    
    static func update(itemID: String) -> URL {
        let percentEncodedID = itemID.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? itemID
        return URL(string: "\(URLS.env.url)items/\(percentEncodedID)")!
    }
    
    static func delete(itemID: String) -> URL {
        let percentEncodedID = itemID.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? itemID
        return URL(string: "\(URLS.env.url)items/\(percentEncodedID)")!
    }
    
    
    //MARK: Users
    static func createUser() -> URL {
        return URL(string: "\(URLS.env.url)users")!
    }
    
    static func getCurrentUser() -> URL {
        return URL(string: "\(URLS.env.url)users")!
    }
    
}
