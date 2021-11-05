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
    @Published var itemToUpdate: SpendingObject?
    @Published var isLoading: Bool = false
    @Published var items = [SpendingObject]()
    let itemDataStore: ItemDataStore
    
    init() {
        itemDataStore = ItemDataStore()
        fetchItems()
    }
    
    
    func calculateSpendings() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            var temp: Double = 0
            switch self.items.count {
            case 0: self.total = 0
            default:
                for item in self.items {
                    if item.type == .expense {
                        temp -= item.amount
                    } else {
                        temp += item.amount
                    }
                    self.total = temp
                }
            }
        }
    }
    
    
    func fetchItems() {
        itemDataStore.fetchItems { result in
            switch result {
            case .failure(let error): print("Error retrieving items: \(error)")
            case .success(let fetchedItems):
                self.items = fetchedItems
                self.calculateSpendings()
            }
        }
    }
    
    
    
    func save(item: SpendingObject) {
        let moc = PersistenceManager.persistentContainer.newBackgroundContext()
        let newItem = Item(context: moc)
        newItem.name = item.name
        newItem.amount = Double(item.amount)
        newItem.type = item.type.rawValue
        newItem.category = item.category
        newItem.date = item.date
        newItem.id = UUID().uuidString
        do {
            try moc.save()
            fetchItems()
        } catch {
            print("Core data error: \(error)")
        }
    }
    
    
    func update(item: SpendingObject) {
        let moc = PersistenceManager.persistentContainer.newBackgroundContext()
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", item.id)
        do {
            guard let result = try moc.fetch(fetchRequest).first else { return }
            print("UPDATE: \(item)")
            result.name = item.name
            result.amount = Double(item.amount)
            result.type = item.type.rawValue
            result.category = item.category
            result.date = item.date
            try moc.saveIfNeeded()
            fetchItems()
        } catch {
            print("Core data error: \(error)")
        }
    }
    
    
    
}
