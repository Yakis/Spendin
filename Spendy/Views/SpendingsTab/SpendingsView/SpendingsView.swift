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
    
    
    @EnvironmentObject var spendingVM: SpendingVM
    @State var showModal: Bool = false
    @State var isUpdate: Bool = false
    @State private var cancellable: AnyCancellable?
    
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 20) {
                SpendingsListView(showModal: $showModal, isUpdate: $isUpdate)
                TotalBottomView(showModal: $showModal, isUpdate: $isUpdate)
                    .onAppear(perform: {
                        spendingVM.getItems()
                    })
                    .environmentObject(spendingVM)
                
            }.background(AdaptColors.container)
            ProgressView("Loading...").opacity(spendingVM.isLoading ? 1 : 0)
        }
    }
    
    
    init() {
        UITableViewCell.appearance().backgroundColor = UIColor.init(named: "CellContainer")
        UITableView.appearance().backgroundColor = UIColor.init(named: "Container")
    }
    
    
}




