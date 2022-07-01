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
    
    @EnvironmentObject var viewModel: SpendingVM
    @Environment(\.presentationMode) var presentationMode
    @State private var cancellable: AnyCancellable?
    @Binding var isUpdate: Bool
    @Binding var date: Date
    @State private var itemTypes = ItemType.allCases
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 20) {
                ScrollView {
                    ItemTypePicker(itemTypes: itemTypes, selectedType: $viewModel.itemToSave.itemType)
                        .padding([.top, .bottom], 5)
                    NameTextField(item: $viewModel.itemToSave)
                    AmountTextField(amount: $viewModel.itemToSave.amount)
                    CategoryPicker(category: $viewModel.itemToSave.category)
                    ItemDatePicker(date: $date)
                    SaveButton(item: viewModel.itemToSave, saveAction: {
                        viewModel.itemToSave.name = viewModel.itemToSave.name.trimmingCharacters(in: .whitespacesAndNewlines)
                        if isUpdate {
                            viewModel.itemToSave.due = date.ISO8601Format()
                            viewModel.update()
                        } else {
                            viewModel.itemToSave.due = date.ISO8601Format()
                            viewModel.save()
                        }
                        presentationMode.wrappedValue.dismiss()
                    })
                    Spacer().frame(height: 300)
                }
                .padding()
                .background(AdaptColors.container)
                .edgesIgnoringSafeArea(.bottom)
            }
            .onChange(of: date, perform: { newValue in
                viewModel.itemToSave.due = newValue.ISO8601Format()
            })
            .onChange(of: viewModel.itemToSave, perform: { newValue in
                print("Item changed: \(newValue)")
            })
            .navigationTitle("Add item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        viewModel.itemToUpdate = nil
                    } label: {
                        Image(systemName: "xmark.circle")
                            .font(.title3)
                    }

                }
            }
        }
    }
    
    
    
}
