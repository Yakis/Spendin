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
    @EnvironmentObject var spendingVM: SpendingVM
    @Binding var showModal: Bool
    @Binding var isUpdate: Bool
    @State private var yPos: CGFloat = 0
    @State private var height: CGFloat = 0
    @State private var size: CGSize = .zero
    @State private var showDeleteRestrictionAlert = false
    @Binding var selectedItem: Item
    
    var body: some View {
            List {
                Section {
                    ForEach(spendingVM.currentList.items!.sorted { $0.due < $1.due }, id: \.self) { item in
                        DetailedListItemCell(item: item, isUpdate: $isUpdate, showModal: $showModal, selectedItem: $selectedItem)
                                .environmentObject(spendingVM)
                    }
                    .onDelete(perform: delete)
                    .listRowBackground(AdaptColors.container)
                }
                
            }
            .padding([.leading, .trailing], 16)
            .listStyle(.plain)
            .onChange(of: spendingVM.currentList.items, {
                spendingVM.calculateSpendings()
            })
    }
    
    
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            if let itemToDelete = spendingVM.currentList.items?[index] {
                modelContext.delete(itemToDelete)
            }
        }
    }
    
    
    
}

