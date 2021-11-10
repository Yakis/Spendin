//
//  SaveButton.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI
import CoreData

struct SaveButton: View {
    
    var item: Item
    var saveAction: () -> ()
    
    var body: some View {
        Button {
            saveAction()
        } label: {
            Text("Save")
                .frame(width: 300, height: 50, alignment: .center)
                .padding(5)
                .background(item.name.isEmpty || item.amount.isEmpty || Double(item.amount) == nil ? .gray : AdaptColors.theOrange)
                .foregroundColor(AdaptColors.container)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .shadow(radius: 5)
                .padding(.all, 20)
        }
        .disabled(item.name.isEmpty || item.amount.isEmpty || Double(item.amount) == nil)
        .opacity(item.name.isEmpty || item.amount.isEmpty || Double(item.amount) == nil ? 0.5 : 1)
    }
    
}
