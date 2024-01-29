//
//  SuggestionEditor.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 01/02/2023.
//

import SwiftUI

struct SuggestionEditor: View {
    
    @Environment(\.spendingVM) private var spendingVM
    @Environment(\.presentationMode) var presentationMode
    @Bindable var suggestion: Suggestion
    @State private var showDeleteConfirmation = false
    var updateAction: () -> ()
    var deleteAction: () -> ()
    @FocusState var isInputActive: Bool
    
    var body: some View {
        VStack {
            TextField(suggestion.name, text: $suggestion.name)
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
                    suggestion.name = ""
                }
            TextField(String(suggestion.amount), text: $suggestion.amount)
                .frame(height: 50)
                .padding(10)
                .focused($isInputActive)
                .keyboardType(.decimalPad)
                .background(AdaptColors.fieldContainer)
                .font(.title)
                .accentColor(AdaptColors.theOrange)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .shadow(color: .black, radius: -4)
                .padding([.top, .bottom], 5)
                .onTapGesture {
                    suggestion.amount.removeAll()
                }
            SuggestionCategoryPicker(suggestion: suggestion)
            Picker("SD", selection: $suggestion.itemType) {
                ForEach(ItemType.allCases, id: \.self) { type in
                    Text(type.rawValue)
                        .tag(type.rawValue)
                }
            }
            .accentColor(AdaptColors.theOrange)
            VStack {
                Button {
                    updateAction()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Update")
                        .padding(5)
                }
                .buttonStyle(.borderedProminent)
                .clipShape(Capsule())
                .tint(AdaptColors.theOrange)
                Spacer()
                Button {
                    showDeleteConfirmation = true
                } label: {
                    Text("Delete")
                        .foregroundColor(AdaptColors.theOrange)
                        .padding(5)
                }
                .buttonStyle(.plain)
                .clipShape(Capsule())
            }.padding([.top, .bottom])
        }
        .padding([.leading, .trailing], 16)
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Are you sure you want to delete this suggestion?"),
                message: Text("There is no undo."),
                primaryButton: .destructive(Text("Delete")) {
                    deleteAction()
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    
}
