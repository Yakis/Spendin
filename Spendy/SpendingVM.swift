//
//  SpendingVM.swift
//  Spendtrack
//
//  Created by Mugurel on 13/07/2020.
//

import Foundation
import CoreData


class SpendingVM: ObservableObject {
    
    
    @Published var total: Double = 0
    
    
    
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
