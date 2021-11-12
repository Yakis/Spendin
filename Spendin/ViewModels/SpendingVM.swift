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
    @Published var lists = [ItemList]()
    @Published var currentList = ItemList()
    @Published var shareableList: CDList?
    @Published var suggestions = [Suggestion]()
    let itemDataStore: ItemDataStore
    let listDataStore: ListDataStore
    let suggestionDataStore: SuggestionDataStore
    
    init() {
        itemDataStore = ItemDataStore()
        listDataStore = ListDataStore()
        suggestionDataStore = SuggestionDataStore()
        fetchSuggestions()
        fetchLists()
    }
    
    
    func calculateSpendings() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            var temp: Double = 0
            switch self.currentList.items.count {
            case 0: self.total = 0
            default:
                self.currentList.items.enumerated().forEach {
                    guard !$1.date.isPast() else { return }
                    if $1.type == .expense {
                        temp -= Double($1.amount)!
                        self.currentList.items[$0].amountLeft = String(format: "%.2f", temp)
                    } else {
                        temp += Double($1.amount)!
                        self.currentList.items[$0].amountLeft = String(format: "%.2f", temp)
                    }
                    self.total = temp
                }
            }
        }
    }
    
    
    func fetchLists() {
        listDataStore.fetchLists { result in
            switch result {
            case .failure(let error): print("Error retrieving items: \(error)")
            case .success(let fetchedLists):
                self.lists = fetchedLists
                self.currentList = fetchedLists.first ?? ItemList()
                print("Lists: \(self.lists.map { $0.name })")
                self.calculateSpendings()
            }
        }
    }
    
    
    
    func save(list: ItemList) {
        listDataStore.save(list: list) { result in
            switch result {
            case .failure(let error): print("Error saving item: \(error)")
            case .success(_):
                fetchLists()
            }
        }
    }
    
    
    func update(list: ItemList) {
        listDataStore.update(list: list) { result in
            switch result {
            case .failure(let error): print("Error updating item: \(error)")
            case .success(_):
                fetchLists()
                list.items.forEach { item in saveSuggestion(item: item) }
            }
        }
    }
    
    
    func save(item: Item) {
        itemDataStore.save(item: item, list: currentList) { result in
            switch result {
            case .failure(let error): print("Error saving item: \(error)")
            case .success(_):
                fetchLists()
                saveSuggestion(item: item)
            }
        }
    }
    
    
    func update(item: Item) {
        itemDataStore.update(item: item) { result in
            switch result {
            case .failure(let error): print("Error updating item: \(error)")
            case .success(_):
                fetchLists()
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
