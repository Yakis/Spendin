//
//  NewListView.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 16/11/2021.
//

import SwiftUI


struct CreateNewListView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var spendingVM: SpendingVM
    @State private var listName = ""
    
    
    var body: some View {
        VStack {
            Image(systemName: "pencil.circle.fill")
                .resizable()
                .frame(width: 60, height: 60, alignment: .center)
                .foregroundColor(AdaptColors.theOrange)
                .padding()
            Text("New list")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom, 30)
                .opacity(0.5)
            TextField("List name", text: $listName)
                .frame(height: 50)
                .padding(10)
                .keyboardType(.alphabet)
                .background(AdaptColors.fieldContainer)
                .font(.title)
                .accentColor(AdaptColors.theOrange)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .shadow(color: .black, radius: -4)
                .padding(.top, 5)
                .padding(.bottom, 20)
            Button {
                let list = ItemList(name: listName)
                spendingVM.save(list: list)
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save")
                    .frame(width: 300, height: 50, alignment: .center)
                    .padding(5)
                    .background(listName.isEmpty ? .gray : AdaptColors.theOrange)
                    .foregroundColor(AdaptColors.container)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .shadow(radius: 5)
                    .padding(.all, 20)
            }
            .disabled(listName.isEmpty)
            .opacity(listName.isEmpty ? 0.5 : 1)
        }
        .frame(maxHeight: .infinity)
        .padding()
    }
    
    
}
