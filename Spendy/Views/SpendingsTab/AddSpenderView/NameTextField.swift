//
//  NameTextField.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI

struct NameTextField: View {
    
    @Binding var name: String
    
    var body: some View {
        TextField("Name", text: $name)
            .frame(height: 50)
            .padding(10)
            .background(AdaptColors.cellContainer)
            .font(.title)
            .accentColor(AdaptColors.theOrange)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(color: .black, radius: -4)
            .padding([.top, .bottom], 5)
        
    }
}
