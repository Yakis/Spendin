//
//  SaveButton.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI
import CoreData

struct SaveButton: View {
    
    var saveAction: () -> ()
    
    var body: some View {
        Button("Save") {
            saveAction()
        }
        .frame(width: UIScreen.main.bounds.width / 2, height: 50, alignment: .center)
        .background(AdaptColors.theOrange)
        .foregroundColor(AdaptColors.container)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(radius: 5)
        .padding(.all, 20)
    }
    
}
