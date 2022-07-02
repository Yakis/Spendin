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
    @State private var yPos: CGFloat = 0
    @State private var height: CGFloat = 0
    @State private var size: CGSize = .zero
    
    var body: some View {
        List {
            ForEach(0..<spendingVM.currentListItems.count, id: \.self) { index in
                if let item = spendingVM.currentListItems[index] {
                    DetailedListItemCell(item: item, index: index, isUpdate: $isUpdate, showModal: $showModal)
                        .environmentObject(spendingVM)
                }
            }
            .onDelete(perform: delete)
            .listRowBackground(AdaptColors.cellBackground)
        }
        .listStyle(InsetGroupedListStyle())
        .onChange(of: spendingVM.currentListItems) { newValue in
            spendingVM.calculateSpendings()
        }
    }
    
    
    private func delete(at offsets: IndexSet) {
        let item = spendingVM.currentListItems[offsets.first!]
        Task {
            try await spendingVM.delete(item: item)
            spendingVM.currentListItems.remove(at: offsets.first!)
        }
    }
    

    
}

