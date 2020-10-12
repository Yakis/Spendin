//
//  SaveButton.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI

struct SaveButton: View {
    
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var viewModel: SpendingVM
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(key: "date", ascending: true)]) var items: FetchedResults<Item>
    
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
        let newItem = Item(context: moc)
        newItem.name = name
        newItem.amount = Double(amount) ?? 0
        newItem.type = selectedType
        newItem.category = category
        newItem.date = date
        newItem.id = UUID()
        do {
            try self.moc.save()
            presentationMode.wrappedValue.dismiss()
            viewModel.calculateSpendings(items: items.reversed())
        } catch {
            print("Core data error: \(error)")
        }
    }
    
    
    private func update() {
        if let item = viewModel.itemToUpdate {
            item.name = name
            item.amount = Double(amount) ?? 0
            item.type = selectedType
            item.category = category
            item.date = date
            do {
                try self.moc.save()
                presentationMode.wrappedValue.dismiss()
                viewModel.calculateSpendings(items: items.reversed())
                viewModel.itemToUpdate = nil
                self.isUpdate = false
            } catch {
                print("Core data error: \(error)")
            }
        }
    }
    
}
