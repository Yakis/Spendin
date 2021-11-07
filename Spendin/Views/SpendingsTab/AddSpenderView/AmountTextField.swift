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
        TextField("Amount", text: $amount)
            .frame(height: 50)
            .padding(10)
            .background(AdaptColors.fieldContainer)
            .font(.title)
            .keyboardType(.decimalPad)
            .accentColor(AdaptColors.theOrange)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(color: .black, radius: -4)
            .padding([.top, .bottom], 5)
            
        
    }
    
}

