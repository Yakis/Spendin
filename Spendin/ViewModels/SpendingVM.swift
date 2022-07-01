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
    @Published var currentList: ItemList?
    @Published var currentListItems: [Item] = []
    @Published var lists: [ItemList] = []
    @Published var suggestions = [Suggestion]()
    @Published var amountList: Dictionary<Int, String> = [:]
    @Published var itemToSave: Item = Item()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchSuggestions()
        fetchLists()
    }
    
    
    func calculateSpendings() {
        var temp: Double = 0
        switch currentListItems.count {
        case 0: self.total = 0
        default:
            currentListItems.enumerated().forEach {
                if $1.itemType == .expense {
                    temp -= Double($1.amount)!
                    self.amountList[$0] = String(format: "%.2f", temp)
                } else {
                    temp += Double($1.amount)!
                    self.amountList[$0] = String(format: "%.2f", temp)
                }
                self.total = temp
            }
        }
    }
    
    
    func fetchLists() {
        Task {
            self.lists = try! await ListService.getAllLists()
            self.currentList = lists.first
            self.currentListItems = await getItemsFor(currentList!.id).sorted { $0.date < $1.date }
        }
    }
    
    
    
    
    func getListFor(id: String) async {
        let _ = try? await ListService.getList(for: id)
    }
    
    
    func getItemsFor(_ listID: String) async -> [Item] {
        return try! await ItemService.getItems(for: listID)
    }
    
    
    func save(list: ItemList) {
        
    }
    
    
    func update(list: ItemList) {
        
    }
    
    
    func save() {
        Task {
            guard let currentList = currentList else { return }
            try await ItemService.save(item: itemToSave, listID: currentList.id)
            currentListItems = try! await ItemService.getItems(for: currentList.id)
            itemToUpdate = nil
            itemToSave = Item()
        }
    }

    
    func update() {
        Task {
            guard let currentList = currentList else { return }
            try await ItemService.update(item: itemToSave)
            currentListItems = try! await ItemService.getItems(for: currentList.id)
            itemToUpdate = nil
            itemToSave = Item()
        }
    }
    
    func delete(item: Item) async throws {
//        try await itemDataStore.delete(item: item)
    }
    
    
    
    func saveSuggestion(item: Item) {
        
    }
    
    
    func fetchSuggestions() {
        
    }
    
    
    func deleteSuggestions() {
//        suggestionDataStore.deleteSuggestions()
        suggestions.removeAll()
    }
    
}
