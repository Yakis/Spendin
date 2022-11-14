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
    @Published var currentUser: User? = nil
    @Published var sharedList: ItemList?
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: Sharing
    @Published var readOnly = true
    @Published var shortenedURL: URL = URL(string: "https://yakis.cloud")!
    
    
    init() {
        getCurrentUser()
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
                guard let isAuthenticated = notification.userInfo?["isAuthenticated"] as? Bool else { return }
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
    
    
    
    func getCurrentUser() {
        print("Getting current user")
        isLoading = true
        Task {
            guard !KeychainItem.currentUserIdentifier.isEmpty else {
                isLoading = false
                return
            }
            self.currentUser = try await ListService.getCurrentUser()
            print("CURRENT USER ===> \(self.currentUser)")
            self.fetchLists()
            self.registerForListIndexChange()
            self.registerForAuthStatus()
        }
    }
    
    
    
    func fetchLists() {
        print("Fetching lists")
        Task {
            if let ids = currentUser?.lists, !ids.isEmpty {
                let uuids = ids.map { UUID(uuidString: $0)! }
                lists = try await ListService.getUserLists(ids: uuids)
                currentListItems.removeAll()
                guard !lists.isEmpty else { return }
                let currentList = lists[currentListIndex]
                currentListItems = await getItemsFor(currentList.id)
                fetchSuggestions()
            }
            isLoading = false
        }
    }
    
    
    
    
    func getListFor(id: String) {
        Task {
            sharedList = try? await ListService.getList(for: id)
        }
    }
    
    
    func getItemsFor(_ listID: String) async -> [Item] {
        currentListItems.removeAll()
        isLoading = true
        do {
            let items = try await ItemService.getItems(for: listID)
            isLoading = false
            return items
        } catch {
            print("Error getting items: \(error)")
            return []
        }
    }
    
    
    func save(list: ItemList) {
        Task {
            try await ListService.save(list: list)
            getCurrentUser()
        }
    }
    
    
    func update(list: ItemList) {
        Task {
            let _ = try await ListService.update(list.name, for: list.id)
        }
    }
    
    
    func acceptInvitation(for userDetails: UserDetails, to list: ItemList) {
        Task {
            let _ = try await ListService.acceptInvitation(for: userDetails, to: list.id)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.getCurrentUser()
            }
        }
    }
    
    func stopSharing(user userID: String, from listID: String) {
        Task {
            let _ = try await ListService.stopSharing(for: userID, from: listID)
        }
    }
    
    func update(user privileges: UserPrivileges, for listID: String) {
        Task {
            let _ = try await ListService.update(user: privileges, for: listID)
        }
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
        fetchLists()
    }
    
    
    func delete(list: ItemList) async throws {
        isLoading = true
        guard let index = lists.firstIndex(of: list) else { return }
        try await ListService.delete(list: list)
        lists.remove(at: index)
        currentListIndex = max(index - 1, 0)
        isLoading = false
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
    
    
    
    func shorten() async throws {
        let longURL = "com.spendin://lists?list=\(lists[currentListIndex].id)&readonly=\(readOnly)"
        let shortened = try await ListService.shorten(url: longURL)
        self.shortenedURL = URL(string: shortened.short)!
    }
    
    
    func fetchShortened(id: String) async throws -> String {
        return try await ListService.fetchShortened(id: id)
    }
    
    
}
