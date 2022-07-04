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
    @Published var isLoading: Bool = false
    @Published var isAuthenticated: Bool = false
    @Published var currentListIndex: Int = 0
    @Published var currentListItems: [Item] = []
    @Published var lists: [ItemList] = []
    @Published var suggestions = [Suggestion]()
    @Published var amountList: Dictionary<Int, String> = [:]
    @Published var itemToSave: Item = Item()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchSuggestions()
        fetchLists()
        registerForListIndexChange()
        registerForAuthStatus()
    }
    
    
    private func registerForListIndexChange() {
        $currentListIndex
            .sink { newIndex in
                guard !self.lists.isEmpty else { return }
                let listID = self.lists[newIndex].id
                Task {
                    self.currentListItems = await self.getItemsFor(listID)
                }
            }
            .store(in: &cancellables)
    }
    
    
    private func registerForAuthStatus() {
        NotificationCenter.default.publisher(for: .authDidChange)
            .sink { [weak self] notification in
                guard let self = self else { return }
                guard let isAuthenticated = notification.userInfo?["isAuthenticated"] as?Bool else { return }
                print("Is authenticated: \(isAuthenticated)")
                if isAuthenticated {
                    self.fetchLists()
                } else {
                    self.currentListItems.removeAll()
                    self.lists.removeAll()
                    self.suggestions.removeAll()
                    self.currentListIndex = 0
                }
            }
            .store(in: &cancellables)
            
    }
    
    
    func calculateSpendings() {
        var temp: Double = 0
        switch currentListItems.count {
        case 0: self.total = 0
        default:
            currentListItems.enumerated().forEach {
                if $1.itemType == .expense {
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
    
    
    func fetchLists() {
        Task {
            lists = try await ListService.getAllLists()
            currentListItems.removeAll()
            guard !lists.isEmpty else { return }
            let currentList = lists[currentListIndex]
            currentListItems = await getItemsFor(currentList.id).sorted { $0.date < $1.date }
            fetchSuggestions()
        }
    }
    
    
    
    
    func getListFor(id: String) async {
        let _ = try? await ListService.getList(for: id)
    }
    
    
    func getItemsFor(_ listID: String) async -> [Item] {
        currentListItems.removeAll()
        return try! await ItemService.getItems(for: listID)
    }
    
    
    func save(list: ItemList) {
        Task {
            try await ListService.save(list: list)
            fetchLists()
        }
    }
    
    
    func update(list: ItemList) {
        
    }
    
    
    func saveItem() {
        Task {
            let currentList = lists[currentListIndex]
            try await ItemService.save(item: itemToSave, listID: currentList.id)
            saveSuggestion(item: itemToSave)
            fetchLists()
            itemToSave = Item()
        }
    }
    
    
    func updateItem() {
        Task {
            try await ItemService.update(item: itemToSave)
            saveSuggestion(item: itemToSave)
            fetchLists()
            itemToSave = Item()
        }
    }
    
    func delete(item: Item) async throws {
        try await ItemService.delete(item: item)
    }
    
    
    func delete(list: ItemList) async throws {
        guard let index = lists.firstIndex(of: list) else { return }
        try await ListService.delete(list: list)
        lists.remove(at: index)
        currentListIndex = max(lists.count - 1, 0)
    }
    
    
    func saveSuggestion(item: Item) {
        Task {
            let suggestion = Suggestion(name: item.name, type: item.itemType, category: item.category, amount: item.amount, count: 0)
            if suggestions.contains(where: { $0.name == suggestion.name }) {
                try await SuggestionService.update(suggestion: suggestions.filter({ $0.name == suggestion.name }).first!)
            } else {
                try await SuggestionService.save(suggestion: suggestion)
            }
        }
        fetchSuggestions()
    }
    
    
    func fetchSuggestions() {
        Task {
            suggestions = try await SuggestionService.getSuggestions()
        }
    }
    
    
    func deleteSuggestions() {
        Task {
            try await SuggestionService.deleteAllSuggestions()
            suggestions.removeAll()
        }
    }
    
    
    func delete(suggestion: Suggestion) {
        Task {
            try await SuggestionService.delete(suggestion: suggestion)
            suggestions.removeAll()
        }
    }
    
}
