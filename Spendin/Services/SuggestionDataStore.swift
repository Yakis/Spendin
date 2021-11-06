//
//  SuggestionDataStore.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 06/11/2021.
//

import Foundation
import CoreData

class SuggestionDataStore {
    
    
    func isAlreadySaved(name: String) -> Bool {
        let moc = PersistenceManager.persistentContainer.newBackgroundContext()
        let fetchRequest: NSFetchRequest<CDSuggestion>
        fetchRequest = CDSuggestion.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        let count = try! moc.count(for: fetchRequest)
        return count > 0
    }
    
    
    
    func fetchSuggestions(completion: @escaping(Result<[Suggestion], Error>) -> ()) {
        let moc = PersistenceManager.persistentContainer.newBackgroundContext()
        let fetchRequest = CDSuggestion.sortedFetchRequest
        do {
            let result = try moc.fetch(fetchRequest)
            completion(.success(result.map { Suggestion(from: $0) }))
        } catch {
            completion(.failure(error))
        }
    }
    
    
    func saveSuggestion(item: Item, handler: @escaping() -> ()) {
        let moc = PersistenceManager.persistentContainer.newBackgroundContext()
        guard !self.isAlreadySaved(name: item.name) else {
            let fetchRequest: NSFetchRequest<CDSuggestion>
            fetchRequest = CDSuggestion.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name = %@", item.name)
            do {
                let result = try moc.fetch(fetchRequest)
                guard let fetchedSuggestion = result.first else {
                    return
                }
                let currentValue = fetchedSuggestion.count
                fetchedSuggestion.count = currentValue + 1
                try moc.saveIfNeeded()
                handler()
            } catch {
                print("Error updating count field on read article: \(error)")
            }
            return
        }
        let newSuggestion = CDSuggestion(context: moc)
        newSuggestion.name = item.name
        newSuggestion.type = item.type.rawValue
        newSuggestion.category = item.category
        newSuggestion.amount = Double(item.amount)!
        newSuggestion.count = 1
        do {
            try moc.saveIfNeeded()
            handler()
        } catch {
            print(error)
        }
    }
    
    
    
}
