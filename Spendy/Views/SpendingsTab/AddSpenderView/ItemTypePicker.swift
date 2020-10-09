//
//  ItemTypePicker.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI

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
