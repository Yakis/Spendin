//
//  SaveButton.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI

struct SaveButton: View {
    
    @Environment(\.spendingVM) private var spendingVM
    @Bindable var item: Item
    var saveAction: () -> ()
    
    var body: some View {
        Button {
            saveAction()
        } label: {
            Text("Save")
                .frame(width: 300, height: 50, alignment: .center)
                .padding(5)
                .background((item.name.isEmpty || item.amount.isEmpty) ? .gray : AdaptColors.theOrange)
                .foregroundColor(AdaptColors.container)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .shadow(radius: 5)
                .padding(.all, 20)
        }
        .disabled((item.name.isEmpty || item.amount.isEmpty))
        .opacity((item.name.isEmpty || item.amount.isEmpty) ? 0.5 : 1)
    }
    
}
