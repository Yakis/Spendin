//
//  SaveButton.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI

struct SaveButton: View {
    
    @EnvironmentObject var viewModel: SpendingVM
    @Environment(\.presentationMode) var presentationMode
    
    var name: String
    var amount: String
    var category: String
    var date: Date
    var selectedType: String
    
    @Binding var isUpdate: Bool
    
    var body: some View {
        Button("Save") {
            if isUpdate {
                update()
            } else {
                save()
            }
        }
        .frame(width: UIScreen.main.bounds.width / 2, height: 50, alignment: .center)
        .background(AdaptColors.theOrange)
        .foregroundColor(AdaptColors.container)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(radius: 5)
        .padding(.all, 20)
    }
    
    
    
    
    private func save() {
        let newItem = Item(id: "", amount: Double(amount) ?? 0, category: category, date: date, name: name, type: selectedType)
        viewModel.save(item: newItem)
            presentationMode.wrappedValue.dismiss()
    }
    
    
    private func update() {
        if viewModel.itemToUpdate != nil {
            viewModel.itemToUpdate?.name = name
            viewModel.itemToUpdate?.amount = Double(amount) ?? 0
            viewModel.itemToUpdate?.type = selectedType
            viewModel.itemToUpdate?.category = category
            viewModel.itemToUpdate?.date = date
            viewModel.update()
            presentationMode.wrappedValue.dismiss()
            viewModel.itemToUpdate = nil
            self.isUpdate = false
        }
    }
    
}
