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
    @Published var currentList: CDList?
    @Published var suggestions = [Suggestion]()
    let itemDataStore: ItemDataStore
    let listDataStore: ListDataStore
    let suggestionDataStore: SuggestionDataStore
    @Published var amountList: Dictionary<Int, String> = [:]
    private var cancellables = Set<AnyCancellable>()
    
    
    init() {
        itemDataStore = ItemDataStore()
        listDataStore = ListDataStore()
        suggestionDataStore = SuggestionDataStore()
        fetchSuggestions()
//        fetchLists()
        registerToRemoteStoreChanges()
    }
    
    
    func registerToRemoteStoreChanges() {
        NotificationCenter.default
            .publisher(for: .NSPersistentStoreRemoteChange)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .sink { notification in
//                self.fetchLists()
            }
            .store(in: &cancellables)
    }
    
    
    func calculateSpendings() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            var temp: Double = 0
            switch self.currentList?.itemsArray.count {
            case 0: self.total = 0
            default:
                self.currentList?.itemsArray.enumerated().forEach {
//                    guard !$1.date.isPast() else { return }
                    if $1.type == "expense" {
                        temp -= $1.amount
                        self.amountList[$0] = String(format: "%.2f", temp)
                    } else {
                        temp += $1.amount
                        self.amountList[$0] = String(format: "%.2f", temp)
                    }
                    self.total = temp
                }
            }
        }
    }
    
    func getListFor(id: String) -> CDList? {
        return listDataStore.getListFor(id: id)
    }
    
    
    
    func save(list: ItemList) {
        listDataStore.save(list: list) { result in
            switch result {
            case .failure(let error): print("Error saving item: \(error)")
            case .success(_):
                self.calculateSpendings()
            }
        }
    }
    
    
    func update(list: ItemList) {
        listDataStore.update(list: list) { result in
            switch result {
            case .failure(let error): print("Error updating item: \(error)")
            case .success(_):
                self.calculateSpendings()
                list.items.forEach { item in self.saveSuggestion(item: item) }
            }
        }
    }
    
    
    func save(item: Item) {
        itemDataStore.save(item: item, list: currentList) { result in
            switch result {
            case .failure(let error): print("Error saving item: \(error)")
            case .success(_):
                self.calculateSpendings()
                self.saveSuggestion(item: item)
            }
        }
    }
    
    
    func update(item: Item) {
        itemDataStore.update(item: item) { result in
            switch result {
            case .failure(let error): print("Error updating item: \(error)")
            case .success(_):
                calculateSpendings()
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
                DispatchQueue.main.async {
                    self.suggestions = fetchedSuggestions                    
                }
            }
        }
    }
    
    
    func deleteSuggestions() {
        suggestionDataStore.deleteSuggestions()
        suggestions.removeAll()
    }
    
}
