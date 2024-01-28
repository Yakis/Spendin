//
//  AmountTextField.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI

struct AmountTextField: View {
    
    @Environment(\.spendingVM) private var spendingVM
    @Bindable var item: Item
    var body: some View {
        TextField("Amount", text: $item.amount)
            .frame(height: 50)
            .padding(10)
            .background(AdaptColors.fieldContainer)
            .font(.title)
            .keyboardType(.decimalPad)
            .accentColor(AdaptColors.theOrange)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(color: .black, radius: -4)
            .padding([.top, .bottom], 5)
            .onTapGesture {
                item.amount.removeAll()
            }
    }
    
}

