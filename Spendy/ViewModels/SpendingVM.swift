//
//  SpendingVM.swift
//  Spendtrack
//
//  Created by Mugurel on 13/07/2020.
//

import SwiftUI
import Combine

class SpendingVM: ObservableObject {
    
    @Published var total: Double = 0
    @Published var itemToUpdate: Item?
    @Published var isLoading: Bool = false
    @Published var items: [Item] = []
    var firebaseService: FirebaseService
    
    init() {
        firebaseService = FirebaseService()
    }
    
    func calculateSpendings() {
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
    
    
    func getItems() {
        firebaseService.getItems { [weak self] (items, error) in
            if error != nil {
                print("Error retrieving items: \(String(describing: error))")
            } else {
                if let items = items {
                    self?.items = items
                    self?.calculateSpendings()
                }
            }
        }
    }
    
    
    
    func save(item: Item) {
        firebaseService.save(item: item) { [weak self] (error) in
            if error != nil {
                print(error)
            } else {
                self?.getItems()
            }
        }
    }
    
    
    func update() {
        firebaseService.update(item: itemToUpdate!) { [weak self] (error) in
            if error != nil {
                print("Error updating item: \(error)")
            } else {
                self?.getItems()
            }
        }
    }
    
    
    func delete(item: Item) {
        firebaseService.delete(item: item) { [weak self] (error) in
            if error != nil {
                print("Error deleting item: \(error)")
            } else {
                self?.getItems()
            }
        }
    }
    
}
