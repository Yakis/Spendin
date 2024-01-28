//
//  NameTextField.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI
import SwiftData

struct NameTextField: View {
    
    @Environment(\.spendingVM) private var spendingVM
    @FocusState var isInputActive: Bool
    @Query(sort: \Suggestion.name, order: .forward) private var suggestions: [Suggestion]
    @Bindable var item: Item
    var onSuggestionTap: (Suggestion) -> ()
    
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
            .onTapGesture {
                item.name.removeAll()
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    SuggestionsBand(suggestions: suggestions) { suggestion in
                        onSuggestionTap(suggestion)
                        isInputActive = false
                    }
                }
            }
    }
}


@ViewBuilder
func SuggestionsBand(suggestions: [Suggestion], onSuggestionTap: @escaping (Suggestion) -> ()) -> some View {
    ScrollView(.horizontal, showsIndicators: false) {
        LazyHGrid(rows: [GridItem.init(.flexible(minimum: 40, maximum: 100), spacing: 10, alignment: .center)]) {
            ForEach(suggestions, id: \.name) { suggestion in
                Text(suggestion.name)
                    .font(.caption)
                    .foregroundColor(AdaptColors.container)
                    .padding(5)
                    .background(suggestion.itemType == .expense ? AdaptColors.theOrange : Color.green)
                    .clipShape(Capsule())
                    .padding(5)
                    .onTapGesture(perform: {
                        onSuggestionTap(suggestion)
                    })
            }
        }
    }.frame(maxHeight: 40)
}
