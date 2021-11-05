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
    
    @State private var date: Date = Date()
    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var categories: [String] = ["car.fill", "doc.fill", "cross.circle.fill", "airpodspro", "cart.fill", "signpost.right.fill", "creditcard.fill", "books.vertical.fill", "camera.fill", "phone.fill", "bag.fill", "paintbrush.pointed.fill", "bandage.fill", "hammer.fill", "printer.fill", "case.fill", "house.fill", "key.fill", "tv.fill", "iphone.homebutton", "hifispeaker.fill", "guitars.fill", "bus.fill", "tram.fill", "bed.double.fill", "pills.fill", "sportscourt", "photo.fill", "camera.aperture", "shield.lefthalf.fill", "gamecontroller.fill", "paintpalette.fill", "sdcard", "headphones", "gift.fill", "airplane", "banknote.fill", "minus.plus.batteryblock.fill", "lightbulb.fill", "at.circle.fill"]
    @State private var category: String = "cart.fill"
    @State private var itemTypes = ItemType.allCases
    @State private var selectedType: ItemType = .expense
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            ScrollView {
                XmarkView().environmentObject(viewModel)
                ItemTypePicker(itemTypes: itemTypes, selectedType: $selectedType)
                    .padding([.top, .bottom], 5)
                NameTextField(name: $name)
                AmountTextField(amount: $amount)
                CategoryPicker(categories: categories, category: $category)
                ItemDatePicker(date: $date)
                SaveButton(saveAction: {
                    if let itemToUpdate = viewModel.itemToUpdate {
                        let newItem = SpendingObject(id: itemToUpdate.id, name: name, amount: Double(amount) ?? 0, category: category, date: date, type: selectedType)
                        viewModel.update(item: newItem)
                    } else {
                        let newItem = SpendingObject(id: UUID().uuidString, name: name, amount: Double(amount) ?? 0, category: category, date: date, type: selectedType)
                        viewModel.save(item: newItem)
                    }
                    presentationMode.wrappedValue.dismiss()
                })
                    .environmentObject(viewModel)
                Spacer().frame(height: 300)
            }
            .padding()
            .background(AdaptColors.container)
            .edgesIgnoringSafeArea(.bottom)
        }
        .onAppear {
            if isUpdate {
                if let item = viewModel.itemToUpdate {
                    name = item.name
                    date = item.date
                    amount = "\(item.amount)"
                    category = item.category
                    selectedType = item.type
                    
                }
            }
        }
    }
    
}































