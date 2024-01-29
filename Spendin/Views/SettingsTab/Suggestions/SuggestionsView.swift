//
//  SuggestionsView.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 22/11/2022.
//

import SwiftUI
import SwiftData

struct SuggestionsView: View {
    
    @Environment(\.spendingVM) private var spendingVM
    @Environment(\.modelContext) var modelContext
    
    @Query var suggestions: [Suggestion]
    
    
    @State private var showSuggestionEditor = false
    @State private var columns = [
        GridItem.init(.flexible(minimum: 80, maximum: 150), spacing: 3),
        GridItem.init(.flexible(minimum: 80, maximum: 150), spacing: 3),
        GridItem.init(.flexible(minimum: 80, maximum: 150), spacing: 3)
    ]
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Text("Suggestions will automatically fill your fields when adding an item. A suggestion is automatically created when you first add an item, and you can edit them here afterwards.")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(8)
            VStack(alignment: .leading) {
                Text("Incomes")
                    .textCase(.uppercase)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .padding(.top, 16)
                LazyVGrid(columns: columns, alignment: .leading, spacing: 16) {
                    ForEach(suggestions.filter { $0.itemType == .income }, id: \.name) { suggestion in
                        SuggestionSettingsCell(suggestion: suggestion, tapAction: { selected in
                            spendingVM.selectedSuggestion = selected
                            self.showSuggestionEditor = true
                        })
                    }
                }
            }
            VStack(alignment: .leading) {
                Text("Expenses")
                    .textCase(.uppercase)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .padding(.top, 16)
                LazyVGrid(columns: columns, alignment: .leading, spacing: 16) {
                    ForEach(suggestions.filter { $0.itemType == .expense }, id: \.name) { suggestion in
                        SuggestionSettingsCell(suggestion: suggestion, tapAction: { selected in
                            spendingVM.selectedSuggestion = selected
                            self.showSuggestionEditor = true
                        })
                    }
                }
            }
        }
        .padding([.leading, .trailing], 16)
        .navigationTitle(Text("Suggestions"))
        .navigationBarTitleDisplayMode(.large)
        .popover(isPresented: $showSuggestionEditor, content: {
            CloseableView {
                SuggestionEditor(suggestion: spendingVM.selectedSuggestion,
                                 updateAction: {
                    try? modelContext.save()
                }, deleteAction: {
                    modelContext.delete(spendingVM.selectedSuggestion)
                })
            }
        })
    }
    
}



struct SuggestionSettingsCell: View {
    
    @Environment(\.spendingVM) private var spendingVM
    var suggestion: Suggestion
    var tapAction: (Suggestion) -> ()
    
    var body: some View {
        VStack {
            Label(suggestion.name, systemImage: suggestion.category)
                .lineLimit(1)
                .padding(8)
                .background(suggestion.itemType == .expense ? AdaptColors.theOrange : Color.green)
                .clipShape(Capsule())
        }
        .onTapGesture {
            tapAction(suggestion)
        }
    }
    
}
