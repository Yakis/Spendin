//
//  SpendingsView.swift
//  Spendtrack
//
//  Created by Mugurel Moscaliuc on 10/07/2020.
//

import SwiftUI
import Combine
import CoreData

enum ItemType: String, CaseIterable {
    case expense, income
}



struct SpendingsView: View {
    
    
    @EnvironmentObject var itemStore: ItemStorage
    @EnvironmentObject var spendingVM: SpendingVM
    @Environment(\.managedObjectContext) var moc
    @State var showModal: Bool = false
    @State var isUpdate: Bool = false
    @State private var isLoading: Bool = true
    @State private var cancellable: AnyCancellable?
    
    
    var body: some View {
        ZStack {
        VStack(alignment: .leading, spacing: 20) {
            SpendingsListView(showModal: $showModal, isUpdate: $isUpdate)
                .environmentObject(itemStore)
            TotalBottomView(showModal: $showModal, isUpdate: $isUpdate)
                .environmentObject(itemStore)
            .onAppear(perform: {
                cancellable = itemStore.$sortedItems
                    .sink { items in
                        for item in items {
                            print("Item: \(item.name)")
                            print("Amount: \(item.amount)")
                        }
                        }
                    
                isLoading = false
                spendingVM.calculateSpendings(items: itemStore.sortedItems.shuffled())
            })
                .environmentObject(spendingVM)
                .environmentObject(itemStore)
            
        }.background(AdaptColors.container)
            ProgressView("Syncing data...").opacity(spendingVM.isLoading ? 1 : 0)
        }
    }
    
    
     init() {
        UITableViewCell.appearance().backgroundColor = UIColor.init(named: "CellContainer")
        UITableView.appearance().backgroundColor = UIColor.init(named: "Container")
    }
    
    
}




