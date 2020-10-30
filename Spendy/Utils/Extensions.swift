//
//  Extensions.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import Foundation

extension Date {
    
    func shortString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_UK")
        return dateFormatter.string(from: self)
    }
    
}

