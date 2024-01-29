//
//  AddSpenderView.swift
//  Spendtrack
//
//  Created by Mugurel Moscaliuc on 11/07/2020.
//

import SwiftUI
import SwiftData
import Combine

struct AddSpenderView: View {
    
    @Query private var suggestions: [Suggestion]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.spendingVM) private var spendingVM
    @Environment(\.presentationMode) var presentationMode
    @State private var cancellable: AnyCancellable?
    @Binding var isUpdate: Bool
    @State private var itemTypes = ItemType.allCases
    @State private var showSuggestionEditor = false
    var list: ItemList
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 20) {
                ScrollView {
                    ItemTypePicker(itemTypes: itemTypes, item: spendingVM.itemToSave)
                        .padding([.top, .bottom], 5)
                    NameTextField(
                        item: spendingVM.itemToSave,
                        onSuggestionTap: onSuggestionTap(_:)
                    )
                    AmountTextField(item: spendingVM.itemToSave)
                    CategoryPicker(item: spendingVM.itemToSave)
                    ItemDatePicker(item: spendingVM.itemToSave)
                    SaveButton(
                        item: spendingVM.itemToSave,
                        saveAction: {
                        if !isUpdate {
                            list.items!.append(spendingVM.itemToSave)
                            try? modelContext.save()
                        }
                        saveSuggestion(spendingVM.itemToSave)
                        presentationMode.wrappedValue.dismiss()
                        spendingVM.calculateSpendings(list: list)
                    })
                    Spacer().frame(height: 300)
                }
                .padding()
                .background(AdaptColors.container)
                .edgesIgnoringSafeArea(.bottom)
            }
            .navigationTitle(isUpdate ? "Update item" : "Add item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        spendingVM.itemToSave = Item()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .font(.title3)
                            .foregroundColor(AdaptColors.theOrange)
                    }
                    
                }
            }
        }
    }
    
    
    
    private func saveSuggestion(_ item: Item) {
        if !suggestions.contains(where: { $0.name == item.name }) {
            let suggestion = Suggestion(name: item.name, itemType: item.itemType, category: item.category, amount: item.amount, count: 0)
            modelContext.insert(suggestion)
            try? modelContext.save()
        }
    }
    
    
    
    private func onSuggestionTap(_ suggestion: Suggestion) {
        var newItem = Item(name: suggestion.name, amount: suggestion.amount, category: suggestion.category, due: spendingVM.itemToSave.due, itemType: suggestion.itemType)
        spendingVM.itemToSave = newItem
        print("================================================")
        print(spendingVM.itemToSave.name)
        print(spendingVM.itemToSave.amount)
        print(spendingVM.itemToSave.itemType)
        print(spendingVM.itemToSave.category)
        print(spendingVM.itemToSave.due)
        print(spendingVM.itemToSave.amountLeft)
        print("================================================")
    }
    
}
