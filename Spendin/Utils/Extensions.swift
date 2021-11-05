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


extension Item {
  static var sortedFetchRequest: NSFetchRequest<Item> {
    let request: NSFetchRequest<Item> = Item.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
    return request
  }
}
