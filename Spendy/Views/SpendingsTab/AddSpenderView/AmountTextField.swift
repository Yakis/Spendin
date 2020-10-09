//
//  AmountTextField.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI

struct AmountTextField: View {
    
    @Binding var amount: String
    
    var body: some View {
        HStack {
            Spacer().frame(width: 20, height: 10, alignment: .center)
            TextField("Amount", text: $amount)
                .frame(height: 50)
                .keyboardType(.decimalPad)
                .accentColor(AdaptColors.theOrange)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: .black, radius: -4)
                .padding([.top, .bottom], 20)
            Spacer().frame(width: 20, height: 10, alignment: .center)
        }
    }
    
}

