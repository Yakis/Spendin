//
//  ListDataStore.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 11/11/2021.
//

import Foundation
import CoreData

class ListDataStore {
    
    func fetchLists(completion: @escaping(Result<[ItemList], Error>) -> ()) {
        let moc = PersistenceManager.persistentContainer.newBackgroundContext()
        let fetchRequest = CDList.sortedFetchRequest
        do {
            let result = try moc.fetch(fetchRequest)
            completion(.success(result.map { ItemList(from: $0) }))
        } catch {
            completion(.failure(error))
        }
    }
    
    
    func getListForID(id: String) -> CDList {
        let moc = PersistenceManager.persistentContainer.newBackgroundContext()
        let fetchRequest: NSFetchRequest<CDList> = CDList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        return try! moc.fetch(fetchRequest).first!
    }
    
    
    func update(list: ItemList, completion: (Result<ItemList, Error>) -> ()) {
        let moc = PersistenceManager.persistentContainer.newBackgroundContext()
        let fetchRequest: NSFetchRequest<CDList> = CDList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", list.id)
        do {
            guard let result = try moc.fetch(fetchRequest).first else { return }
            result.name = list.name
            result.created = list.created
            result.shared = list.shared
            let items = result.mutableSetValue(forKey: "items")
            list.items.forEach { newItem in
                let item = CDItem(context: moc)
                item.name = newItem.name
                item.amount = Double(newItem.amount)!
                item.type = newItem.type.rawValue
                item.category = newItem.category
                item.date = newItem.date
                item.list = result
                items.add(item)
            }
            try moc.saveIfNeeded()
            completion(.success(ItemList(from: result)))
        } catch {
            completion(.failure(error))
            print("Core data error: \(error)")
        }
    }
    
    
    func save(list: ItemList, completion: (Result<ItemList, Error>) -> ()) {
        let moc = PersistenceManager.persistentContainer.newBackgroundContext()
        let newList = CDList(context: moc)
        newList.name = list.name
        newList.created = list.created
        newList.shared = list.shared
        newList.id = UUID().uuidString
        do {
            try moc.saveIfNeeded()
            completion(.success(ItemList(from: newList)))
        } catch {
            completion(.failure(error))
        }
    }
    
    
}
