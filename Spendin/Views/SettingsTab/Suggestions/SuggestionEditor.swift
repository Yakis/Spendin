//
//  SuggestionEditor.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 01/02/2023.
//

import SwiftUI

struct SuggestionEditor: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var suggestion: Suggestion?
    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var category: String = ""
    @State private var type: ItemType = .expense
    @State private var typeOptions = ItemType.allCases
    @State private var showDeleteConfirmation = false
    var updateAction: () -> ()
    var deleteAction: () -> ()
    @FocusState var isInputActive: Bool
        
    var body: some View {
        VStack {
            if let suggestion = suggestion {
                TextField(suggestion.name, text: $name)
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
                    .onChange(of: name, perform: { newValue in
                        // name changed
                    })
                    .onTapGesture {
                        name.removeAll()
                    }
                TextField(String(suggestion.amount), text: $amount)
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
                    .onChange(of: amount, perform: { newValue in
                        // name changed
                    })
                    .onTapGesture {
                        amount.removeAll()
                    }
                CategoryPicker(category: $category)
                Picker("SD", selection: $type) {
                    ForEach(typeOptions, id: \.rawValue) { type in
                        Text(type.rawValue)
                            .tag(type)
                    }
                }
                .accentColor(AdaptColors.theOrange)
                VStack {
                    Button {
                        self.suggestion!.name = name.isEmpty ? suggestion.name : name
                        self.suggestion!.amount = amount.isEmpty ? suggestion.amount : try! Double(value: amount)
                        self.suggestion!.category = category.isEmpty ? suggestion.category : category
                        self.suggestion!.itemType = suggestion.itemType == type ? suggestion.itemType : type
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
        }
        .padding([.leading, .trailing], 16)
        .onAppear {
            name = suggestion!.name
            amount = String(suggestion!.amount)
            type = suggestion!.itemType
            category = suggestion!.category
        }
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
