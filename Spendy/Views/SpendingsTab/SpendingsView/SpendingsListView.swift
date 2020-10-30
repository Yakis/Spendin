//
//  SpendingsListView.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI

struct SpendingsListView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    @Binding var showModal: Bool
    @Binding var isUpdate: Bool
    
    var body: some View {
        List {
            ForEach(spendingVM.items, id: \.self) { item in
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
        guard let index = indexSet.first else { return }
        let item = spendingVM.items[index]
        spendingVM.delete(item: item)
    }
    
    
    
    
}


