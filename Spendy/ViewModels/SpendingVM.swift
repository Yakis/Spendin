//
//  SpendingVM.swift
//  Spendtrack
//
//  Created by Mugurel on 13/07/2020.
//

import SwiftUI
import CoreData
import Combine

class SpendingVM: ObservableObject {
    
    @Published var total: Double = 0
    @Published var itemToUpdate: Item?
    @Published var isLoading: Bool = false
    
    
    
    func calculateSpendings(items: [Item]) {
        DispatchQueue.main.async {
            var temp: Double = 0
            switch items.count {
            case 0: self.total = 0
            default:
                for item in items {
                    if item.type == "expense" {
                        temp -= item.amount
                    } else {
                        temp += item.amount
                    }
                    self.total = temp
                }
            }
        }
    }
    
    
    
}
