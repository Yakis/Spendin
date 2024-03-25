//
//  SpendingVM.swift
//  Spendtrack
//
//  Created by Mugurel on 13/07/2020.
//

import SwiftUI
import Observation

@Observable
final class SpendingVM {
    
    var total: Double = 0
    var isLoading: Bool = false
    var suggestions = [Suggestion]()
    var amountList: Dictionary<String, String> = [:]
    var itemToSave: Item?
    var selectedSuggestion = Suggestion()
            
    
    
    func onSuggestionTap(_ suggestion: Suggestion) {
//        var newItem = Item(name: suggestion.name, amount: suggestion.amount, category: suggestion.category, due: itemToSave.due, itemType: suggestion.itemType)
//        itemToSave = newItem
//        print("================================================")
//        print(itemToSave.name)
//        print(itemToSave.amount)
//        print(itemToSave.itemType)
//        print(itemToSave.category)
//        print(itemToSave.due)
//        print(itemToSave.amountLeft)
        print("================================================")
    }
    
    
    
    func calculateSpendings(list: ItemList) {
        var temp: Double = 0
        switch list.items?.count {
        case 0: self.total = 0
        default:
            list.items?.sorted { $0.due < $1.due }.forEach {
                if $0.itemType == .expense {
                    temp -= Double($0.amount)!
                    self.amountList[$0.amount + $0.name] = String(format: "%.2f", temp)
                } else {
                    temp += Double($0.amount)!
                    self.amountList[$0.amount + $0.name] = String(format: "%.2f", temp)
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
