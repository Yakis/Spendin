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
    
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            NavigationView {
                SpendingsViewContent()
                    .background(AdaptColors.container)
                    .navigationTitle("Spendings")
            }
        } else {
            SpendingsViewContent()
//                .background(AdaptColors.container)
                .navigationTitle("Spendings")
        }
    }
    
    
}



struct SpendingsViewContent: View {
    @EnvironmentObject var spendingVM: SpendingVM
    @State var showModal: Bool = false
    @State var isUpdate: Bool = false
    @State private var isLoading: Bool = true
    @State private var cancellable: AnyCancellable?
    
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 20) {
                SpendingsListView(showModal: $showModal, isUpdate: $isUpdate)
                TotalBottomView(showModal: $showModal, isUpdate: $isUpdate)
                    .environmentObject(spendingVM)
                
            }
            .background(AdaptColors.container)
            ProgressView("Syncing data...").opacity(spendingVM.isLoading ? 1 : 0)
        }
    }
    
    
    init() {
        UITableViewCell.appearance().backgroundColor = UIColor.init(named: "CellContainer")
        UITableView.appearance().backgroundColor = UIColor.init(named: "Container")
    }
}
