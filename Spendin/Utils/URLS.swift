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
            return "https://a38e-82-37-115-33.eu.ngrok.io/"
        case .production:
            return "http://88.208.241.68/"
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
    
    static func allLists() -> URL {
        return URL(string: "\(URLS.env.url)lists")!
    }
    
    static func saveList() -> URL {
        return URL(string: "\(URLS.env.url)lists")!
    }
    
    static func delete(listID: String) -> URL {
        let percentEncodedID = listID.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? listID
        return URL(string: "\(URLS.env.url)lists/\(percentEncodedID)")!
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
    
}
