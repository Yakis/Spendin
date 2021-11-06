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
    @Binding var showModal: Bool
    @Binding var isUpdate: Bool
    
    var body: some View {
        List {
            ForEach(spendingVM.items, id: \.id) { item in
                SpendingsListCell(item: item, isUpdate: $isUpdate, showModal: $showModal)
                    .environmentObject(spendingVM)
                
            }
            .onDelete {
                delete(item: spendingVM.items[$0.first!])
            }
            .listRowBackground(Color.white.opacity(0.3))
        }.listStyle(InsetGroupedListStyle())
    }
    
    
    private func delete(item: Item) {
        let moc = PersistenceManager.persistentContainer.newBackgroundContext()
        let fetchRequest: NSFetchRequest<CDItem>
        fetchRequest = CDItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", item.id)
        let itemsToDelete = try! moc.fetch(fetchRequest)
        for item in itemsToDelete {
            moc.delete(item)
            do {
                try moc.saveIfNeeded()
                spendingVM.fetchItems()
            } catch {
                print(error)
            }
        }
    }
    
    
    
    
}


