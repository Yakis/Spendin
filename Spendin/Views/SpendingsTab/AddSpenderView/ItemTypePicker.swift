//
//  ItemTypePicker.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI

struct ItemTypePicker: View {
    
    @Environment(\.spendingVM) private var spendingVM
    var itemTypes: [ItemType]
    @Bindable var item: Item
    
    var body: some View {
        Picker(selection: $item.itemType, label: Text("")) {
            ForEach(itemTypes, id: \.self) { type in
                Text(type.rawValue)
                    .tag(type.rawValue)
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
    
    
}
