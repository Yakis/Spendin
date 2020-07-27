//
//  Extensions.swift
//  Spendy
//
//  Created by Mugurel on 24/07/2020.
//

import Foundation


extension Array where Element: Hashable {
    func diff(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
