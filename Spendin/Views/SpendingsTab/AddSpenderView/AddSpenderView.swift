//
//  AddSpenderView.swift
//  Spendtrack
//
//  Created by Mugurel Moscaliuc on 11/07/2020.
//

import SwiftUI
import CoreData
import Combine

struct AddSpenderView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    @Environment(\.presentationMode) var presentationMode
    @State private var cancellable: AnyCancellable?
    @Binding var isUpdate: Bool
    @Binding var date: Date
    @State private var itemTypes = ItemType.allCases
    @State private var suggestions = [Suggestion]()
    
    @State private var selectedType: ItemType = .expense
    @State private var amount: String = ""
    @State private var name: String = ""
    @State private var selectedCategory: String = "cart.fill"
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 20) {
                ScrollView {
                    ItemTypePicker(itemTypes: itemTypes, selectedType: $selectedType)
                        .padding([.top, .bottom], 5)
                    NameTextField(itemName: $name, suggestions: $suggestions, onNameChange: {
                        onNameChange()
                    }, onSuggestionTap: { suggestion in
                        onSuggestionTap(suggestion)
                    })
                    AmountTextField(amount: $amount)
                    CategoryPicker(category: $selectedCategory)
                    ItemDatePicker(date: $date)
                    SaveButton(disabled: (name.isEmpty || amount.isEmpty), saveAction: {
                        spendingVM.itemToSave = Item(id: spendingVM.itemToSave.id, name: name.trimmingCharacters(in: .whitespacesAndNewlines), amount: Double(amount)!, category: selectedCategory, due: date.ISO8601Format(), type: selectedType)
                        if isUpdate {
                            spendingVM.updateItem()
                        } else {
                            spendingVM.saveItem()
                        }
                        presentationMode.wrappedValue.dismiss()
                    })
                    Spacer().frame(height: 300)
                }
                .padding()
                .background(AdaptColors.container)
                .edgesIgnoringSafeArea(.bottom)
            }
            .onAppear(perform: {
                setupFields()
            })
            .navigationTitle("Add item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        spendingVM.itemToSave = Item()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .font(.title3)
                    }

                }
            }
        }
    }
    
    
    
    func onNameChange() {
        if name.isEmpty {
            suggestions = spendingVM.suggestions
        } else {
            suggestions = spendingVM.suggestions.filter { suggestion in
                suggestion.name.contains(name)
            }
        }
    }
    
    
    func onSuggestionTap(_ suggestion: Suggestion) {
        name = suggestion.name
        amount = String(suggestion.amount)
        selectedType = suggestion.type
        selectedCategory = suggestion.category
    }
    
    
    func setupFields() {
        if isUpdate {
            name = spendingVM.itemToSave.name
            amount = String(spendingVM.itemToSave.amount)
            date = spendingVM.itemToSave.due.isoToDate()
            selectedType = spendingVM.itemToSave.itemType
            selectedCategory = spendingVM.itemToSave.category
        }
        suggestions = spendingVM.suggestions
    }
    
}
