//
//  ItemManager.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 04/11/2021.
//

import Foundation
import CoreData

class ItemDataStore {
    
    
    //    func fetchItems(completion: @escaping(Result<[Item], Error>) -> ()) {
    //        let moc = PersistenceManager.persistentContainer.newBackgroundContext()
    //        let fetchRequest = CDItem.sortedFetchRequest
    //        do {
    //            let result = try moc.fetch(fetchRequest)
    //            completion(.success(result.map { Item(from: $0) }))
    //        } catch {
    //            completion(.failure(error))
    //        }
    //    }
    
    
    func update(item: Item) async throws {
        let moc = PersistenceManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CDItem>
        fetchRequest = CDItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", item.id)
        let results = try! moc.fetch(fetchRequest)
//        await moc.perform {
            print("Service: \(Thread.current)")
            for itemToUpdate in results {
                itemToUpdate.objectWillChange.send()
                itemToUpdate.name = item.name
                itemToUpdate.amount = Double(item.amount) ?? 0
                itemToUpdate.type = item.type.rawValue
                itemToUpdate.category = item.category
                itemToUpdate.date = item.date
                print("CDItem to update: \(String(describing: itemToUpdate.id))")
            }
            try! moc.saveIfNeeded()
            return
//        }
    }
    //
    //
    //    func save(item: Item, list: CDList?, completion: @escaping (Result<Item, Error>) -> ()) {
    //        let moc = PersistenceManager.persistentContainer.newBackgroundContext()
    //        let newItem = CDItem(context: moc)
    //        newItem.name = item.name
    //        newItem.amount = Double(item.amount) ?? 0
    //        newItem.type = item.type.rawValue
    //        newItem.category = item.category
    //        newItem.date = item.date
    //        newItem.id = UUID().uuidString
    //        if let list = list {
    //            newItem.list = moc.object(with: list.objectID) as? CDList
    //            newItem.list?.title = newItem.list?.title
    //        }
    //        do {
    //            try moc.saveIfNeeded()
    //            completion(.success(Item(from: newItem)))
    //        } catch {
    //            completion(.failure(error))
    //        }
    //    }
    //
    //
    func delete(item: CDItem) async throws {
        let moc = PersistenceManager.persistentContainer.newBackgroundContext()
        let fetchRequest: NSFetchRequest<CDItem>
        fetchRequest = CDItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", item.id!)
        guard let itemToDelete = try! moc.fetch(fetchRequest).first else { return }
        itemToDelete.list?.title = itemToDelete.list?.title
        moc.delete(itemToDelete)
        do {
            try moc.saveIfNeeded()
            print("Item \(String(describing: itemToDelete.name)) deleted.")
            return
        } catch {
            print("Error deleting item: \(error)")
        }
    }
    
    
}
