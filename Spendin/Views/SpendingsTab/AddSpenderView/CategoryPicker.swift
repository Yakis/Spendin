//
//  CategoryPicker.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI

struct CategoryPicker: View {
    
    @Binding var category: String
    @State private var revealDetails: Bool = false
    @State private var categories: [String] = ["car.fill", "doc.fill", "cross.circle.fill", "airpodspro", "cart.fill", "signpost.right.fill", "creditcard.fill", "books.vertical.fill", "camera.fill", "phone.fill", "bag.fill", "paintbrush.pointed.fill", "bandage.fill", "hammer.fill", "printer.fill", "case.fill", "house.fill", "key.fill", "tv.fill", "iphone.homebutton", "hifispeaker.fill", "guitars.fill", "bus.fill", "tram.fill", "bed.double.fill", "pills.fill", "sportscourt", "photo.fill", "camera.aperture", "shield.lefthalf.fill", "gamecontroller.fill", "paintpalette.fill", "sdcard", "headphones", "gift.fill", "airplane", "banknote.fill", "minus.plus.batteryblock.fill", "lightbulb.fill", "at.circle.fill"]
    
    let columns = [
        GridItem(.adaptive(minimum: 60))
    ]
    
    var body: some View {
        HStack {
            let image = Image(systemName: category)
            DisclosureGroup("Pick a category   \(image)", isExpanded: $revealDetails) {
                Spacer()
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(categories, id: \.self) { item in
                        Image(systemName: item)
                            .font(.title)
                            .foregroundColor(self.category == item ? AdaptColors.theOrange : AdaptColors.adaptText)
                            .onTapGesture {
                                withAnimation {
                                    self.category = item
                                    self.revealDetails.toggle()
                                }
                            }
                    }
                }
            }
            .font(.title)
            .accentColor(AdaptColors.theOrange)
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
