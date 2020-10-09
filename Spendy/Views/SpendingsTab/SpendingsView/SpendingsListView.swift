//
//  SpendingsListView.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI
import CoreData

struct SpendingsListView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    var moc: NSManagedObjectContext
    var items: FetchedResults<Item>
    @Binding var showModal: Bool
    @Binding var isUpdate: Bool
    
    var body: some View {
        List {
            ForEach(items, id: \.self) { item in
                SpendingsListCell(item: item)
                .onTapGesture {
                    isUpdate = true
                    showModal = true
                    spendingVM.itemToUpdate = item
                }
                
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
            moc.delete(items[index])
            try moc.save()
            spendingVM.calculateSpendings(items: items.shuffled())
        } catch {
            print("Deleting item error: \(error.localizedDescription)")
        }
    }
    
    
    
    
}


