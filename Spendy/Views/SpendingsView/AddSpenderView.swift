//
//  AddSpenderView.swift
//  Spendtrack
//
//  Created by Mugurel Moscaliuc on 11/07/2020.
//

import SwiftUI
import CoreData

struct AddSpenderView: View {
    
    @EnvironmentObject var viewModel: SpendingVM
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(entity: Item.entity(), sortDescriptors: [])
        var items: FetchedResults<Item>
    @FetchRequest(entity: Suggestion.entity(), sortDescriptors: [])
        var suggestions: FetchedResults<Suggestion>
    
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
                XmarkView()
                NameTextField(name: $name, suggestions: suggestions.shuffled())
                ItemTypePicker(itemType: itemType, selectedType: $selectedType)
                AmountTextField(amount: $amount)
                CategoryPicker(categories: categories, category: $category)
                ItemDatePicker(date: $date)
                SaveButton(name: name, amount: amount, category: category, date: date, selectedType: selectedType)
                    .environmentObject(viewModel)
            }
            .padding()
            .background(AdaptColors.container)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
}





struct XmarkView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: "xmark")
                .resizable()
                .frame(width: 20, height: 20, alignment: .trailing)
                .padding(.all, 30)
                .foregroundColor(Color.init("Adapt Text"))
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
        }
    }
}



struct NameTextField: View {
    
    @Binding var name: String
    var suggestions: [Suggestion]
    @State var showSuggestions = true
    
    var body: some View {
        HStack {
            Spacer().frame(width: 20, height: 10, alignment: .center)
            TextField("Name", text: $name)
                .accentColor(AdaptColors.theOrange)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: .black, radius: -4)
                .padding([.top, .bottom], 20)
            HStack {
            ForEach(suggestions.filter { $0.text?.contains(name) ?? false }, id: \.self) { suggestion in
                Text("\(suggestion.text ?? "")")
                    .padding(.all, 10)
                    .background(Color.green)
                    .clipShape(Capsule(style: .circular))
                    .onTapGesture {
                        name = suggestion.text!
                        showSuggestions.toggle()
                    }
            }
            }
            .disabled(!showSuggestions)
            .opacity(showSuggestions ? 1 : 0)
            Spacer().frame(width: 20, height: 10, alignment: .center)
        }
    }
}



struct ItemTypePicker: View {
    
    var itemType: [String]
    @Binding var selectedType: String
    
    var body: some View {
        Picker(selection: $selectedType, label: Text("")) {
            ForEach(itemType, id: \.self) { type in
                Text(type)
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
    
    
}




struct AmountTextField: View {
    
    @Binding var amount: String
    
    var body: some View {
        HStack {
            Spacer().frame(width: 20, height: 10, alignment: .center)
            TextField("Amount", text: $amount)
                .keyboardType(.decimalPad)
                .accentColor(AdaptColors.theOrange)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: .black, radius: -4)
                .padding([.top, .bottom], 20)
            Spacer().frame(width: 20, height: 10, alignment: .center)
        }
    }
    
}



struct CategoryPicker: View {
    
    var categories: [String]
    @Binding var category: String
    @State private var revealDetails: Bool = false
    
    let columns = [
        GridItem(.adaptive(minimum: 60))
    ]
    
    var body: some View {
        HStack {
            DisclosureGroup("Pick a category   \(Image(systemName: category))", isExpanded: $revealDetails) {
                Spacer()
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(categories, id: \.self) { item in
                        Image(systemName: item)
                            .foregroundColor(self.category == item ? AdaptColors.theOrange : AdaptColors.adaptText)
                            .onTapGesture {
                                withAnimation {
                                    self.category = item
                                    self.revealDetails.toggle()
                                }
                            }
                    }
                }
            }.accentColor(AdaptColors.theOrange)
            .padding([.top, .bottom], 20)
            .onTapGesture {
                withAnimation {
                    self.revealDetails.toggle()
                }
            }
            Spacer()
        }
    }
}



struct ItemDatePicker: View {
    
    @Binding var date: Date
    
    var body: some View {
        VStack(alignment: .leading) {
            DatePicker("Pick a date", selection: $date, displayedComponents: .date)
                .accentColor(AdaptColors.theOrange)
                .background(AdaptColors.container)
                .frame(maxHeight: 350)
            Spacer()
        }.background(AdaptColors.container)
    }
    
    
}



struct SaveButton: View {
    
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var viewModel: SpendingVM
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(key: "date", ascending: true)]) var items: FetchedResults<Item>
    @FetchRequest(entity: Suggestion.entity(), sortDescriptors: []) var suggestions: FetchedResults<Suggestion>
    
    var name: String
    var amount: String
    var category: String
    var date: Date
    var selectedType: String
    
    var body: some View {
        Button("Save") {
            let newItem = Item(context: moc)
            newItem.name = name
            newItem.amount = Double(amount) ?? 0
            newItem.type = selectedType
            newItem.category = category
            newItem.date = date
            newItem.id = UUID()
            if !(suggestions.map { $0.text }.contains(name)) {
            let newSuggestion = Suggestion(context: moc)
            newSuggestion.text = name
            newSuggestion.category = category
            }
            do {
                try self.moc.save()
                presentationMode.wrappedValue.dismiss()
                viewModel.calculateSpendings(items: items.reversed())
            } catch {
                print("Core data error: \(error)")
            }
        }
        .frame(width: UIScreen.main.bounds.width / 2, height: 50, alignment: .center)
        .background(AdaptColors.theOrange)
        .foregroundColor(AdaptColors.container)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(radius: 5)
        .padding(.all, 20)
    }
    
    
}
