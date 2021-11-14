//
//  SpendingsListView.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI
import CoreData

struct SpendingsListView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var spendingVM: SpendingVM
    @Binding var showModal: Bool
    @Binding var isUpdate: Bool
    @State private var yPos: CGFloat = 0
    @State private var height: CGFloat = 0
    @State private var size: CGSize = .zero
    
    var body: some View {
        List {
            ForEach(0..<(spendingVM.currentList?.itemsArray.count ?? 0), id: \.self) { index in
                if let item = spendingVM.currentList?.itemsArray[index] {
                    SpendingsListCell(item: item, index: index, isUpdate: $isUpdate, showModal: $showModal)
                        .environmentObject(spendingVM)
                }
            }
            .onDelete {
                guard let itemToDelete = spendingVM.currentList?.itemsArray[$0.first!] else {return}
                delete(item: itemToDelete)
            }
            .listRowBackground(AdaptColors.cellBackground)
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    
    private func delete(item: CDItem) {
        managedObjectContext.delete(item)
        do {
            try managedObjectContext.saveIfNeeded()
        } catch {
            print(error)
        }
    }
    
    
}

