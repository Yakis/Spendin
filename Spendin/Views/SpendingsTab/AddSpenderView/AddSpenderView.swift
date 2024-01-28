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
    @EnvironmentObject var spendingVM: SpendingVM
    @Environment(\.presentationMode) var presentationMode
    @State private var cancellable: AnyCancellable?
    @Binding var isUpdate: Bool
    @Binding var date: Date
    @State private var itemTypes = ItemType.allCases
    @State private var showSuggestionEditor = false
    var list: ItemList
    @Bindable var item: Item
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 20) {
                ScrollView {
                    ItemTypePicker(itemTypes: itemTypes, selectedType: $item.itemType)
                        .padding([.top, .bottom], 5)
                    NameTextField(
                        itemName: $item.name,
                        onSuggestionTap: onSuggestionTap(_:)
                    )
                    AmountTextField(amount: $item.amount)
                    CategoryPicker(category: $item.category)
                    ItemDatePicker(date: $date)
                    SaveButton(disabled: (item.name.isEmpty || item.amount.isEmpty), saveAction: {
                        item.due = date
                        if !isUpdate {
                            list.items!.append(item)
                            try? modelContext.save()
                        }
                        saveSuggestion(item)
                        presentationMode.wrappedValue.dismiss()
                        spendingVM.calculateSpendings()
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
        item.name = suggestion.name
        item.amount = String(suggestion.amount)
        item.itemType = suggestion.itemType
        item.category = suggestion.category
    }
    
}
