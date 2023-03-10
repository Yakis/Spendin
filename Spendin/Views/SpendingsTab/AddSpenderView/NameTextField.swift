//
//  NameTextField.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI

struct NameTextField: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    @FocusState var isInputActive: Bool
    
    @Binding var itemName: String
    @Binding var suggestions: [Suggestion]
    var onNameChange: () -> ()
    var onSuggestionTap: (_ suggestion: Suggestion) -> ()
    
    var body: some View {
        TextField("Name", text: $itemName)
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
            .onChange(of: itemName, perform: { newValue in
                onNameChange()
            })
            .onTapGesture {
                itemName.removeAll()
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: [GridItem.init(.flexible(minimum: 40, maximum: 100), spacing: 10, alignment: .center)]) {
                            ForEach(suggestions.sorted(by: { $0.count > $1.count }), id: \.id) { suggestion in
                                Text(suggestion.name)
                                    .font(.caption)
                                    .foregroundColor(AdaptColors.container)
                                    .padding(5)
                                    .background(suggestion.itemType == .expense ? AdaptColors.theOrange : Color.green)
                                    .clipShape(Capsule())
                                    .padding(5)
                                    .onTapGesture(perform: {
                                        onSuggestionTap(suggestion)
                                        isInputActive = false
                                    })
                            }
                        }
                    }.frame(maxHeight: 40)
                }
            }
    }
}
