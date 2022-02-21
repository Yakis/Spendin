//
//  SpendingsListView.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI
import CoreData

struct ItemsView: View {
    
    
    @FetchRequest(entity: CDItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CDItem.date, ascending: true)])
    var items: FetchedResults<CDItem>
    
    @EnvironmentObject var spendingVM: SpendingVM
    var list: CDList
    @Binding var showModal: Bool
    @Binding var isUpdate: Bool
    @State private var yPos: CGFloat = 0
    @State private var height: CGFloat = 0
    @State private var size: CGSize = .zero
    
    var body: some View {
        List {
            ForEach(0..<items.filter { $0.list?.objectID == list.objectID }.count, id: \.self) { index in
                if let item = items.filter { $0.list?.objectID == list.objectID }[index] {
                    DetailedListItemCell(item: item, index: index, isUpdate: $isUpdate, showModal: $showModal)
                        .environmentObject(spendingVM)
                }
            }
            .onDelete(perform: delete)
            .listRowBackground(AdaptColors.cellBackground)
        }
        .listStyle(InsetGroupedListStyle())
        .onChange(of: items.filter { $0.list?.objectID == list.objectID }) { newValue in
            print("Items changed!!!")
            spendingVM.calculateSpendings(list: list)
        }
    }
    
    private func delete(at offsets: IndexSet) {
        let itemToDelete = items.filter { $0.list?.objectID == list.objectID }[offsets.first!]
        print("Item to delete: \(String(describing: itemToDelete.name)) - \(itemToDelete.amount)")
        Task {
            do {
                try await spendingVM.delete(item: itemToDelete)
            } catch {
                print("Error deleting item: \(error)")
            }
        }
    }
    

    
}

