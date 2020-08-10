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
    var mocHasChanged = PassthroughSubject<Void, Never>()
    
    
    
//    func fetchData(moc: NSManagedObjectContext) {
//        self.isLoading = true
//        let itemsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
//        let sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
//        itemsFetch.sortDescriptors = sortDescriptors
//        do {
//            let items = try moc.fetch(itemsFetch)
//            mocHasChanged.send()
//            calculateSpendings(items: items as! [Item])
//            self.isLoading = false
//            print(items)
//        } catch {
//            self.isLoading = false
//            print(error)
//        }
//    }
    
    
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
