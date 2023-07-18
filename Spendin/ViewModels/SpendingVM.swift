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
    @Published var currentList: ItemList = ItemList()
    @Published var currentListItems: [Item] = []
    @Published var lists: [ItemList] = []
    @Published var suggestions = [Suggestion]()
    @Published var amountList: Dictionary<Int, String> = [:]
    @Published var itemToSave: Item = Item()
    @Published var selectedSuggestion = Suggestion()
    
    @AppStorage("currency") var currency = "$"
    
    private var cancellables = Set<AnyCancellable>()
    
    
    
    func calculateSpendings() {
        var temp: Double = 0
        switch currentList.items?.count {
        case 0: self.total = 0
        default:
            currentList.items?.enumerated().forEach {
                if $1.itemType == "expense" {
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
    
}
