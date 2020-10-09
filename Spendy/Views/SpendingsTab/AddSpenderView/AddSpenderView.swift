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
    @FetchRequest(entity: Item.entity(), sortDescriptors: [])
    var items: FetchedResults<Item>
    @State private var cancellable: AnyCancellable?
    @Binding var isUpdate: Bool
    
    @State private var date: Date = Date()
    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var categories: [String] = ["car.fill", "doc.fill", "cross.circle.fill", "airpodspro", "cart.fill", "signpost.right.fill", "creditcard.fill", "books.vertical.fill", "camera.fill", "phone.fill", "bag.fill", "paintbrush.pointed.fill", "bandage.fill", "hammer.fill", "printer.fill", "case.fill", "house.fill", "key.fill", "tv.fill", "iphone.homebutton", "hifispeaker.fill", "guitars.fill", "bus.fill", "tram.fill", "bed.double.fill", "pills.fill", "sportscourt", "photo.fill", "camera.aperture", "shield.lefthalf.fill", "gamecontroller.fill", "paintpalette.fill", "sdcard", "headphones", "gift.fill", "airplane", "banknote.fill", "minus.plus.batteryblock.fill", "lightbulb.fill", "at.circle.fill"]
    @State private var category: String = "cart.fill"
    @State private var itemType: [String] = ItemType.allCases.map { $0.rawValue }
    @State private var selectedType: String = "expense"
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            ScrollView {
                XmarkView().environmentObject(viewModel)
                NameTextField(name: $name)
                ItemTypePicker(itemType: itemType, selectedType: $selectedType)
                AmountTextField(amount: $amount)
                CategoryPicker(categories: categories, category: $category)
                ItemDatePicker(date: $date)
                SaveButton(name: name, amount: amount, category: category, date: date, selectedType: selectedType, isUpdate: isUpdate)
                    .environmentObject(viewModel)
            }
            .padding()
            .background(AdaptColors.container)
            .edgesIgnoringSafeArea(.bottom)
        }
        .onAppear {
            if isUpdate {
                if let item = viewModel.itemToUpdate {
                    name = item.name!
                    date = item.date!
                    amount = "\(item.amount)"
                    category = item.category!
                    selectedType = item.type!
                    
                }
            }
        }
    }
    
}































