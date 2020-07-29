//
//  SpendingVM.swift
//  Spendtrack
//
//  Created by Mugurel on 13/07/2020.
//

import SwiftUI


class SpendingVM: ObservableObject {
    
    @Published var total: Double = 0
    @Published var itemToUpdate: Item?
    
    func calculateSpendings(items: [Item]) {
        DispatchQueue.main.async {
            var temp: Double = 0
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
