//
//  SpendingsListView.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI

struct SpendingsListView: View {
    
    @EnvironmentObject var itemStore: ItemStorage
    @EnvironmentObject var spendingVM: SpendingVM
    @Environment(\.managedObjectContext) var moc
    @Binding var showModal: Bool
    @Binding var isUpdate: Bool
    
    var body: some View {
        List {
            ForEach(itemStore.sortedItems, id: \.self) { item in
                SpendingsListCell(item: item, isUpdate: $isUpdate, showModal: $showModal)
                    .environmentObject(spendingVM)
                
            }
            .onDelete {
                delete(indexSet: $0)
            }
            .listRowBackground(AdaptColors.cellContainer)
        }.listStyle(InsetGroupedListStyle())
    }
    
    
    private func delete(indexSet: IndexSet) {
        do {
            guard let index = indexSet.first else { return }
            moc.delete(itemStore.sortedItems[index])
            try moc.save()
            spendingVM.calculateSpendings(items: itemStore.sortedItems.shuffled())
        } catch {
            print("Deleting item error: \(error.localizedDescription)")
        }
    }
    
    
    
    
}


