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
    @State private var yPos: CGFloat = 0
    @State private var height: CGFloat = 0
    @State private var size: CGSize = .zero
    
    var body: some View {
        List {
            ForEach(spendingVM.items, id: \.id) { item in
                SpendingsListCell(item: item, isUpdate: $isUpdate, showModal: $showModal)
                    .environmentObject(spendingVM)
            }
            .onDelete {
                delete(item: spendingVM.items[$0.first!])
            }
            .listRowBackground(AdaptColors.cellBackground)
        }
        .listStyle(InsetGroupedListStyle())
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

