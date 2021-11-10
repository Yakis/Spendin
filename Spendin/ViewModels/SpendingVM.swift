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
    @Published var items = [Item]()
    @Published var suggestions = [Suggestion]()
    let itemDataStore: ItemDataStore
    let suggestionDataStore: SuggestionDataStore
    
    init() {
        itemDataStore = ItemDataStore()
        suggestionDataStore = SuggestionDataStore()
        fetchSuggestions()
        fetchItems()
    }
    
    
    func calculateSpendings() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            var temp: Double = 0
            switch self.items.count {
            case 0: self.total = 0
            default:
                let _ = self.items.enumerated().map {
                    guard !$1.date.isPast() else { return }
                    if $1.type == .expense {
                        temp -= Double($1.amount)!
                        self.items[$0].amountLeft = String(format: "%.2f", temp)
                    } else {
                        temp += Double($1.amount)!
                        self.items[$0].amountLeft = String(format: "%.2f", temp)
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
    
    
    
    func save(item: Item) {
        itemDataStore.save(item: item) { result in
            switch result {
            case .failure(let error): print("Error saving item: \(error)")
            case .success(_):
                fetchItems()
                saveSuggestion(item: item)
            }
        }
    }
    
    
    func update(item: Item) {
        itemDataStore.update(item: item) { result in
            switch result {
            case .failure(let error): print("Error updating item: \(error)")
            case .success(_):
                fetchItems()
                saveSuggestion(item: item)
            }
        }
    }
    
    func saveSuggestion(item: Item) {
        suggestionDataStore.saveSuggestion(item: item) {
        }
    }
    
    
    func fetchSuggestions() {
        suggestionDataStore.fetchSuggestions { result in
            switch result {
            case .failure(let error): print("Error fetching suggestions: \(error)")
            case .success(let fetchedSuggestions):
                self.suggestions = fetchedSuggestions
            }
        }
    }
    
    
    func deleteSuggestions() {
        suggestionDataStore.deleteSuggestions()
        suggestions.removeAll()
    }
    
}
