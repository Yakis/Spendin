//
//  SpendingsListView.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI
import CoreData

struct ItemsView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    @Binding var showModal: Bool
    @Binding var isUpdate: Bool
    var isReadOnly: Bool
    @State private var yPos: CGFloat = 0
    @State private var height: CGFloat = 0
    @State private var size: CGSize = .zero
    @State private var showDeleteRestrictionAlert = false
    
    var body: some View {
        List {
            Section {
                ForEach(0..<spendingVM.currentListItems.count, id: \.self) { index in
                        DetailedListItemCell(index: index, isUpdate: $isUpdate, showModal: $showModal, isReadOnly: isReadOnly)
                            .environmentObject(spendingVM)
                }
                .onDelete(perform: delete)
                .listRowBackground(AdaptColors.container)
            }
            
        }.padding([.leading, .trailing], 16)
        .listStyle(.plain)
        .onChange(of: spendingVM.currentListItems) { newValue in
            spendingVM.calculateSpendings()
        }
    }
    
    
    private func delete(at offsets: IndexSet) {
        guard !isReadOnly else {
            showDeleteRestrictionAlert = true
            return
        }
        let item = spendingVM.currentListItems[offsets.first!]
        Task {
            try await spendingVM.delete(item: item)
            spendingVM.currentListItems.remove(at: offsets.first!)
        }
    }
    
    
    
}

