//
//  SpendingVM.swift
//  Spendtrack
//
//  Created by Mugurel on 13/07/2020.
//

import SwiftUI
import CoreData
import Combine

@MainActor
final class SpendingVM: ObservableObject {
    
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
                print("Remote changes...")
                self.calculateSpendings(list: self.currentList)
                self.total = self.total
            }
            .store(in: &cancellables)
    }
    
    
    func calculateSpendings(list: CDList?) {
        guard let list = list else { return }
        var temp: Double = 0
        print("Items count: \(list.itemsArray.count)")
        switch list.itemsArray.count {
        case 0: self.total = 0
        default:
            list.itemsArray.enumerated().forEach {
                if $1.type == "expense" {
                    temp -= $1.amount
                    self.amountList[$0] = String(format: "%.2f", temp)
                } else {
                    temp += $1.amount
                    self.amountList[$0] = String(format: "%.2f", temp)
                }
                self.total = temp
                print("Items: \(list.itemsArray.map { $0.name! + " - " + String($0.amount) })")
                print("TOTAL========== \(self.total) =========")
            }
        }
    }
    
    
//    func fetchLists() {
//        listDataStore.fetchLists { result in
//            switch result {
//            case .failure(let error): print("Error fetching lists: \(error)")
//            case .success(let lists):
//                if self.currentList == nil {
//                    self.currentList = lists.first
////                    self.calculateSpendings(list: lists.first)
//                } else {
//                    guard let newList = lists.filter { $0.objectID == self.currentList?.objectID }.first else { return }
//                    self.currentList = newList
////                    self.calculateSpendings(list: newList)
//                }
//            }
//        }
//    }
    
    
    
    
    func getListFor(id: String) -> CDList? {
        return listDataStore.getListFor(id: id)
    }
    
    
    
    func save(list: ItemList) {
        listDataStore.save(list: list) { result in
            switch result {
            case .failure(let error): print("Error saving item: \(error)")
            case .success(_): print("List saved.")
//                self.fetchLists()
            }
        }
    }
    
    
    func update(list: ItemList) {
        listDataStore.update(list: list) { result in
            switch result {
            case .failure(let error): print("Error updating item: \(error)")
            case .success(_): list.items.forEach { item in self.saveSuggestion(item: item) }
            }
        }
    }
    
    
//    func save(item: Item) {
//        itemDataStore.save(item: item, list: currentList) { result in
//            switch result {
//            case .failure(let error): print("Error saving item: \(error)")
//            case .success(_):
//                self.saveSuggestion(item: item)
//            }
//        }
//    }
//
//
    func update(item: Item) {
        Task {
            print("VM: \(Thread.current)")
            print("Item to update: \(item.id)")
            try await itemDataStore.update(item: item)
            saveSuggestion(item: item)            
        }
    }
    
    func delete(item: CDItem) async throws {
        try await itemDataStore.delete(item: item)
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
