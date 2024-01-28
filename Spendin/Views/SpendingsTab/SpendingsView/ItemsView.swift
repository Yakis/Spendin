//
//  SpendingsListView.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI
import SwiftData

struct ItemsView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.spendingVM) private var spendingVM
    @Binding var showModal: Bool
    @Binding var isUpdate: Bool
    @State private var yPos: CGFloat = 0
    @State private var height: CGFloat = 0
    @State private var size: CGSize = .zero
    @State private var showDeleteRestrictionAlert = false
    var list: ItemList
    
    var body: some View {
            List {
                Section {
                    ForEach(list.items?.sorted { $0.due < $1.due } ?? [], id: \.self) { item in
                        DetailedListItemCell(item: item, isUpdate: $isUpdate, showModal: $showModal)
                    }
                    .onDelete(perform: delete)
                    .listRowBackground(AdaptColors.container)
                }
                
            }
            .padding([.leading, .trailing], 16)
            .listStyle(.plain)
            .onChange(of: list.items, {
                spendingVM.calculateSpendings(list: list)
            })
    }
    
    
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            if let itemToDelete = list.items?.sorted(by: { $0.due < $1.due })[index], let indexToDelete = list.items?.firstIndex(of: itemToDelete) {
                list.items?.remove(at: indexToDelete)
            }
        }
    }
    
    
    
}

