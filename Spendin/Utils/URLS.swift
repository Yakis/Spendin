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
            return "http://0.0.0.0:8080/"
        case .production:
            return "http://0.0.0.0:8080/"
        }
    }
    
}


import Foundation


//MARK: - Urls

fileprivate struct URLS {

    static let env: ServerEnv = .production
    
}


extension URL {
    
    
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
