//
//  ItemTypePicker.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI

struct ItemTypePicker: View {
    
    var itemTypes: [ItemType]
    @Binding var selectedType: ItemType
    
    var body: some View {
        Picker(selection: $selectedType, label: Text("")) {
            ForEach(itemTypes, id: \.self) { type in
                Text(type.rawValue)
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
    
    
}
