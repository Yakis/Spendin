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
    
    
    @FetchRequest(entity: CDList.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CDList.created, ascending: true)])
    var lists: FetchedResults<CDList>
    
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var viewModel: SpendingVM
    @Environment(\.presentationMode) var presentationMode
    @State private var cancellable: AnyCancellable?
    @Binding var isUpdate: Bool
    var date: Date?
    @State private var categories: [String] = ["car.fill", "doc.fill", "cross.circle.fill", "airpodspro", "cart.fill", "signpost.right.fill", "creditcard.fill", "books.vertical.fill", "camera.fill", "phone.fill", "bag.fill", "paintbrush.pointed.fill", "bandage.fill", "hammer.fill", "printer.fill", "case.fill", "house.fill", "key.fill", "tv.fill", "iphone.homebutton", "hifispeaker.fill", "guitars.fill", "bus.fill", "tram.fill", "bed.double.fill", "pills.fill", "sportscourt", "photo.fill", "camera.aperture", "shield.lefthalf.fill", "gamecontroller.fill", "paintpalette.fill", "sdcard", "headphones", "gift.fill", "airplane", "banknote.fill", "minus.plus.batteryblock.fill", "lightbulb.fill", "at.circle.fill"]
    @State private var itemTypes = ItemType.allCases
    @State private var item: Item = Item()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 20) {
                ScrollView {
                    ItemTypePicker(itemTypes: itemTypes, selectedType: $item.type)
                        .padding([.top, .bottom], 5)
                    NameTextField(item: $item)
                    AmountTextField(amount: $item.amount)
                    CategoryPicker(categories: categories, category: $item.category)
                    ItemDatePicker(date: $item.date)
                    SaveButton(item: item, saveAction: {
                        item.name = item.name.trimmingCharacters(in: .whitespacesAndNewlines)
                        if isUpdate {
                            update(item: item)
                        } else {
                            save(item: item, list: viewModel.currentList)
                        }
                        viewModel.itemToUpdate = nil
                        item = Item()
                        presentationMode.wrappedValue.dismiss()
                    })
                    Spacer().frame(height: 300)
                }
                .padding()
                .background(AdaptColors.container)
                .edgesIgnoringSafeArea(.bottom)
            }
            .onAppear {
                if isUpdate {
                    if let itemToUpdate = viewModel.itemToUpdate {
                        item = itemToUpdate
                    }
                }
                if let date = date {
                    item.date = date
                }
            }
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
    
    
    private func save(item: Item, list: CDList?) {
        let newItem = CDItem(context: moc)
        newItem.name = item.name
        newItem.amount = Double(item.amount) ?? 0
        newItem.type = item.type.rawValue
        newItem.category = item.category
        newItem.date = item.date
        newItem.id = UUID().uuidString
        if let list = list {
            newItem.list = moc.object(with: list.objectID) as? CDList
        }
        do {
            try moc.saveIfNeeded()
            viewModel.saveSuggestion(item: item)
        } catch {
            print("Error saving item: \(error)")
        }
    }
    
    
    private func update(item: Item) {
        let fetchRequest: NSFetchRequest<CDItem> = CDItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", item.id)
        guard let result = try! moc.fetch(fetchRequest).first else { return }
        moc.perform {
            result.name = item.name
            result.amount = Double(item.amount)!
            result.type = item.type.rawValue
            result.category = item.category
            result.date = item.date
            try! moc.saveIfNeeded()
            viewModel.calculateSpendings(list: result.list)
            isUpdate = false
        }
    }
    
    
    
}
