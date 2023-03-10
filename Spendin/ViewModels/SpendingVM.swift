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
    @Published var selectedSuggestion: Suggestion? = nil
    @Published var sharedList: ItemList?
    
    @AppStorage("currency") var currency = "$"
    
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: Sharing
    @Published var readOnly = true
    @Published var shortenedURL: URL = URL(string: "https://yakis.cloud")!
    
    
    init() {
        Task {
            try await getCurrentUser()
        }
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
    
    
    
    func getCurrentUser() async throws {
        isLoading = true
        guard !KeychainItem.currentUserIdentifier.isEmpty else {
            isLoading = false
            return
        }
        self.currentUser = try await ListService.getCurrentUser()
        self.fetchLists()
        self.registerForListIndexChange()
        self.registerForAuthStatus()
    }
    
    
    
    func fetchLists() {
        Task {
            if let ids = currentUser?.lists {
                lists = try await ListService.getUserLists()
                currentListItems.removeAll()
                guard !lists.isEmpty else {
                    isLoading = false
                    return
                }
                let currentList = lists[currentListIndex]
                currentListItems = await getItemsFor(currentList.id)
                try await fetchSuggestions()
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
            try await getCurrentUser()
        }
    }
    
    
    func update(list: ItemList) {
        Task {
            let _ = try await ListService.update(list.name, for: list.id)
        }
    }
    
    
    func acceptInvitation(for userDetails: UserDetails, to list: ItemList) async {
        do {
            let acceptedList = try await ListService.acceptInvitation(for: userDetails, to: list.id)
            lists.append(acceptedList)
        } catch {
            print("Error accepting list: \(error)")
        }
    }
    
    func stopSharing(user userID: String, from listID: String) {
        Task {
            let _ = try await ListService.stopSharing(for: userID, from: listID)
        }
    }
    
    func update(user privileges: UserPrivileges, for listID: String) {
        Task {
            let _ = try await ListService.update(privileges: privileges, listID: listID)
        }
    }
    
    
    func saveItem() {
        Task {
            try await ItemService.save(item: itemToSave)
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
            let suggestion = Suggestion(name: item.name, itemType: item.itemType, category: item.category, amount: item.amount, count: 0)
            if suggestions.contains(where: { $0.name == suggestion.name }) {
                // Just update the counter
                try await SuggestionService.update(suggestion: suggestions.filter({ $0.name == suggestion.name }).first!)
                try await fetchSuggestions()
            } else {
                try await SuggestionService.save(suggestion: suggestion)
                try await fetchSuggestions()
            }
        }
    }
    
    
    func updateSuggestion() {
        Task {
            try await SuggestionService.update(suggestion: selectedSuggestion!)
            try await fetchSuggestions()
            selectedSuggestion = nil
        }
    }
    
    
    func fetchSuggestions() async throws {
        suggestions = try await SuggestionService.getSuggestions()
    }
    
    
    func deleteSuggestion() {
        Task {
            try await SuggestionService.delete(suggestion: selectedSuggestion!)
            if let index = suggestions.firstIndex(of: selectedSuggestion!) {
                suggestions.remove(at: index)
            }
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
    
    
    func loadCurrencies() -> [Currency]? {
        let decoder = JSONDecoder()
        do {
            guard
                let url = Bundle.main.url(forResource: "currencies", withExtension: "json")
            else {
                return nil
            }
            let data = try Data(contentsOf: url)
            let currencies = try decoder.decode([Currency].self, from: data)
            return currencies
        } catch {
            print("Error reading json file: \(error)")
        }
        return nil
    }
    
    
    
    // MARK: JSON backup ---------------------------------------
    //    func saveJSONToDocumentsDirectory(list: ItemList) {
    //        let encoded = try! JSONEncoder().encode(list)
    //        guard let jsonString = String(data: encoded, encoding: String.Encoding.utf8) else { return }
    //        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
    //            let pathWithFilename = documentDirectory.appendingPathComponent("spendin_\(list.name).json")
    //            do {
    //                try jsonString.write(to: pathWithFilename, atomically: true, encoding: .utf8)
    //                let input = try String(contentsOf: pathWithFilename)
    //                let items = try FileManager.default.contentsOfDirectory(atPath: pathWithFilename.absoluteString)
    //                print("===============================")
    //                print(items)
    //                print("===============================")
    //            } catch {
    //                print("Error saving json to documents: \(error)")
    //            }
    //        }
    //    }
    //
    //
    //    @discardableResult func printTimeElapsedWhenRunningCode<T>(title: String, operation: () -> T) -> T {
    //        let startTime = CFAbsoluteTimeGetCurrent()
    //        let result = operation()
    //        let timeElapsed = (CFAbsoluteTimeGetCurrent() - startTime) * 1000
    //        print("Time elapsed for \(title): \(timeElapsed) ms.")
    //        return result
    //    }
    //
    //
    //    func getDocumentsDirectoryUrl() -> URL {
    //        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    //        let documentsDirectory = paths[0]
    //        return documentsDirectory
    //    }
    //
    //
    //    func readFromDocumentsDirectory() {
    //        let fm = FileManager.default
    //        guard let path = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    //
    //        do {
    //            let items = try fm.contentsOfDirectory(atPath: path.absoluteString)
    //
    //            for item in items {
    //                print("Found \(item)")
    //            }
    //        } catch {
    //            print("failed to read directory – bad permissions, perhaps? -> \(error)")
    //        }
    //    }
    
    
}
