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
    @State private var suggestions = [Suggestion]()
    @FocusState var isInputActive: Bool
    
    var body: some View {
        TextField("Name", text: $item.name)
            .frame(height: 50)
            .padding(10)
            .focused($isInputActive)
            .keyboardType(.alphabet)
            .background(AdaptColors.fieldContainer)
            .font(.title)
            .accentColor(AdaptColors.theOrange)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(color: .black, radius: -4)
            .padding([.top, .bottom], 5)
            .onAppear(perform: {
                suggestions = spendingVM.suggestions
            })
            .onChange(of: item.name, perform: { newValue in
                if newValue.isEmpty {
                    suggestions = spendingVM.suggestions
                } else {
                    suggestions = spendingVM.suggestions.filter { suggestion in
                        suggestion.name.contains(item.name)
                    }
                }
            })
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: [GridItem.init(.flexible(minimum: 50, maximum: 100), spacing: 16, alignment: .center)]) {
                            ForEach(suggestions, id: \.name) { suggestion in
                                Button {
                                    item.name = suggestion.name
                                    item.amount = String(format: "%.2f", suggestion.amount)
                                    item.type = ItemType(rawValue: suggestion.type)!
                                    item.category = suggestion.category
                                    isInputActive = false
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
