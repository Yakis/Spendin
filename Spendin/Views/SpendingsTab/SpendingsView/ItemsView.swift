//
//  SpendingsListView.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI
import CoreData

struct ItemsView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: CDItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CDItem.date, ascending: true)])
    var items: FetchedResults<CDItem>
    
    @EnvironmentObject var spendingVM: SpendingVM
    @Binding var showModal: Bool
    @Binding var isUpdate: Bool
    @State private var yPos: CGFloat = 0
    @State private var height: CGFloat = 0
    @State private var size: CGSize = .zero
    
    var body: some View {
        List {
            ForEach(0..<items.filter { $0.list?.objectID == spendingVM.currentList!.objectID }.count, id: \.self) { index in
                if let item = items.filter { $0.list?.objectID == spendingVM.currentList!.objectID }[index] {
                    DetailedListItemCell(item: item, index: index, isUpdate: $isUpdate, showModal: $showModal)
                        .environmentObject(spendingVM)
                }
            }
            .onDelete {
                let itemToDelete = items.filter { $0.list?.objectID == spendingVM.currentList!.objectID }[$0.first!]
                spendingVM.delete(item: itemToDelete)
            }
            .listRowBackground(AdaptColors.cellBackground)
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    
}

