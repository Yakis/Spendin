//
//  SpendingsView.swift
//  Spendtrack
//
//  Created by Mugurel Moscaliuc on 10/07/2020.
//

import SwiftUI
import Combine

enum ItemType: String, CaseIterable {
    case expense, income
}



struct SpendingsView: View {
    
    @FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(key: "date", ascending: true)])
    var items: FetchedResults<Item>
    @EnvironmentObject var spendingVM: SpendingVM
    @Environment(\.managedObjectContext) var moc
    @State var showModal: Bool = false
    @State var isUpdate: Bool = false
    @State private var isLoading: Bool = true
    @State private var cancellable: AnyCancellable?
    
    
    var body: some View {
        ZStack {
        VStack(alignment: .leading, spacing: 20) {
            SpendingsListView(
                moc: moc, items: items,
                showModal: $showModal,
                isUpdate: $isUpdate
            )
            TotalBottomView(showModal: $showModal, isUpdate: $isUpdate)
            .onAppear(perform: {
                isLoading = false
                spendingVM.calculateSpendings(items: items.shuffled())
            })
                .environmentObject(spendingVM)
            
        }.background(AdaptColors.container)
            ProgressView("Syncing data...").opacity(spendingVM.isLoading ? 1 : 0)
        }
    }
    
    
     init() {
        UITableViewCell.appearance().backgroundColor = UIColor.init(named: "CellContainer")
        UITableView.appearance().backgroundColor = UIColor.init(named: "Container")
    }
    
    
}




