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
        HStack {
            Spacer().frame(width: 20, height: 10, alignment: .center)
            TextField("Name", text: $name)
                .frame(height: 50)
                .accentColor(AdaptColors.theOrange)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: .black, radius: -4)
                .padding([.top, .bottom], 20)
            
            Spacer().frame(width: 20, height: 10, alignment: .center)
        }
    }
}
