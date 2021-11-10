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
                    SaveButton(saveAction: {
                        item.name = item.name.trimmingCharacters(in: .whitespacesAndNewlines)
                        if isUpdate {
                            viewModel.update(item: item)
                        } else {
                            viewModel.save(item: item)
                        }
                        viewModel.itemToUpdate = nil
                        item = Item()
                        presentationMode.wrappedValue.dismiss()
                    })
                        .disabled(item.name.isEmpty || item.amount.isEmpty || Double(item.amount) == nil)
                        .opacity(item.name.isEmpty || item.amount.isEmpty || Double(item.amount) == nil ? 0.5 : 1)
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
    
}
