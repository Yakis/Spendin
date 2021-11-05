//
//  ItemManager.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 04/11/2021.
//

import Foundation
import CoreData

class ItemDataStore {
    
    
    func fetchItems(completion: @escaping(Result<[SpendingObject], Error>) -> ()) {
        let moc = PersistenceManager.persistentContainer.newBackgroundContext()
        let fetchRequest = Item.sortedFetchRequest
        do {
            let result = try moc.fetch(fetchRequest)
            completion(.success(result.map { SpendingObject(from: $0) }))
        } catch {
            completion(.failure(error))
        }
    }
    
}
