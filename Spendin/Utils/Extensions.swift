//
//  Extensions.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import Foundation
import CoreData

extension Date {
    
    func shortString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_UK")
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
