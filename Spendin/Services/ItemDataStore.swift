//
//  ItemManager.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 04/11/2021.
//

import Foundation
import CoreData

class ItemDataStore {
    
    
    func fetchItems(completion: @escaping(Result<[Item], Error>) -> ()) {
        let moc = PersistenceManager.persistentContainer.newBackgroundContext()
        let fetchRequest = CDItem.sortedFetchRequest
        do {
            let result = try moc.fetch(fetchRequest)
            completion(.success(result.map { Item(from: $0) }))
        } catch {
            completion(.failure(error))
        }
    }
    
    
    func update(item: Item, completion: (Result<Item, Error>) -> ()) {
        let moc = PersistenceManager.persistentContainer.newBackgroundContext()
        let fetchRequest: NSFetchRequest<CDItem> = CDItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", item.id)
        do {
            guard let result = try moc.fetch(fetchRequest).first else { return }
            print("UPDATE: \(item)")
            result.name = item.name
            result.amount = Double(item.amount)!
            result.type = item.type.rawValue
            result.category = item.category
            result.date = item.date
            try moc.saveIfNeeded()
            completion(.success(Item(from: result)))
        } catch {
            completion(.failure(error))
            print("Core data error: \(error)")
        }
    }
    
    
    func save(item: Item, completion: (Result<Item, Error>) -> ()) {
        let moc = PersistenceManager.persistentContainer.newBackgroundContext()
        let newItem = CDItem(context: moc)
        newItem.name = item.name
        newItem.amount = Double(item.amount)!
        newItem.type = item.type.rawValue
        newItem.category = item.category
        newItem.date = item.date
        newItem.id = UUID().uuidString
        do {
            try moc.saveIfNeeded()
            completion(.success(Item(from: newItem)))
        } catch {
            completion(.failure(error))
        }
    }
    
    
}
