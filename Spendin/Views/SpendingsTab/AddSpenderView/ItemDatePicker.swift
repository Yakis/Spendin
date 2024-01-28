//
//  ItemDatePicker.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI

struct ItemDatePicker: View {
    
    @Bindable var item: Item
    
    var body: some View {
        VStack(alignment: .leading) {
            DatePicker("Pick a date", selection: $item.due, displayedComponents: .date)
                .accentColor(AdaptColors.theOrange)
                .background(AdaptColors.container)
                .frame(maxHeight: 350)
            Spacer()
        }.background(AdaptColors.container)
    }
    
    
}
