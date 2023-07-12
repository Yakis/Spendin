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
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var spendingVM: SpendingVM
    @Environment(\.presentationMode) var presentationMode
    @State private var cancellable: AnyCancellable?
    @Binding var isUpdate: Bool
    @Binding var date: Date
    @State private var itemTypes = ["expense", "income"]
    @State private var suggestions = [Suggestion]()
    
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
                        suggestions: $suggestions
                    )
                    AmountTextField(amount: $item.amount)
                    CategoryPicker(category: $item.category)
                    ItemDatePicker(date: $date)
                    SaveButton(disabled: (item.name.isEmpty || item.amount.isEmpty), saveAction: {
                        item.due = date.ISO8601Format()
                        if !isUpdate {
                            list.items.append(item)
                        }
                        presentationMode.wrappedValue.dismiss()
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
    
    
    
//    func onNameChange() {
//        if name.isEmpty {
//            suggestions = spendingVM.suggestions
//        } else {
//            suggestions = spendingVM.suggestions.filter { suggestion in
//                suggestion.name.contains(name)
//            }
//        }
//    }
//    
//    
//    func onSuggestionTap(_ suggestion: Suggestion) {
//        name = suggestion.name
//        amount = String(suggestion.amount)
//        selectedType = suggestion.itemType
//        selectedCategory = suggestion.category
//    }
//    
//    
//    func setupFields() {
//        if isUpdate {
//            name = spendingVM.itemToSave.name
//            amount = String(spendingVM.itemToSave.amount)
//            date = spendingVM.itemToSave.due.isoToDate()
//            selectedType = spendingVM.itemToSave.itemType
//            selectedCategory = spendingVM.itemToSave.category
//        }
//        suggestions = spendingVM.suggestions
//    }
    
}
