//
//  NameTextField.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI

struct NameTextField: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    @Binding var item: Item
//    @Binding var name: String
    
    var body: some View {
        TextField("Name", text: $item.name)
            .frame(height: 50)
            .padding(10)
            .keyboardType(.alphabet)
            .background(AdaptColors.cellContainer)
            .font(.title)
            .accentColor(AdaptColors.theOrange)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(color: .black, radius: -4)
            .padding([.top, .bottom], 5)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: [GridItem.init(.flexible(minimum: 50, maximum: 100), spacing: 16, alignment: .center)]) {
                            ForEach(spendingVM.suggestions, id: \.name) { suggestion in
                                Button {
                                    item.name = suggestion.name
                                    item.amount = String(format: "%.2f", suggestion.amount)
                                    item.type = ItemType(rawValue: suggestion.type)!
                                    item.category = suggestion.category
                                } label: {
                                    Text(suggestion.name)
                                        .font(.caption)
                                        .foregroundColor(AdaptColors.container)
                                        .padding(5)
                                        .background(AdaptColors.theOrange)
                                        .clipShape(Capsule())
                                        .padding(5)
                                }
                            }
                        }
                    }
                }
            }
    }
}
