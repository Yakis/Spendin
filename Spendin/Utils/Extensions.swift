//
//  Extensions.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import Foundation
import CoreData


extension DateFormatter {
    
    static let reussableFormatter = DateFormatter()
    
}


extension Date {
    
    func shortString() -> String {
        let dateFormatter = DateFormatter.reussableFormatter
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_UK")
        return dateFormatter.string(from: self)
    }
    
    func monthName() -> String {
        let dateFormatter = DateFormatter.reussableFormatter
        dateFormatter.locale = Locale(identifier: "en_UK")
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
}


extension CDItem {
  static var sortedFetchRequest: NSFetchRequest<CDItem> {
    let request: NSFetchRequest<CDItem> = CDItem.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
    return request
  }
}


extension CDSuggestion {
  static var sortedFetchRequest: NSFetchRequest<CDSuggestion> {
    let request: NSFetchRequest<CDSuggestion> = CDSuggestion.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "count", ascending: false)]
    return request
  }
}
