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
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: CDList.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CDList.title, ascending: true)])
    var lists: FetchedResults<CDList>
    
    @EnvironmentObject var spendingVM: SpendingVM
    @State private var selectedList: ItemList?
    @State private var showDetailedList = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(lists, id: \.id) { list in
                    VStack(alignment: .leading) {
                        Text(list.title ?? "No name").font(.title3).padding(5)
                        Text("Items: \(list.items?.count ?? 0)").font(.caption).padding(5)
                    }.onTapGesture {
                        spendingVM.currentList = ItemList(from: list)
                        showDetailedList = true
                    }
                }
                .onDelete {
                    delete(list: spendingVM.lists[$0.first!])
                }
            }
            .popover(isPresented: $showDetailedList) {
                SpendingsViewContent()
                    .background(AdaptColors.container)
                    .navigationTitle("Spendings")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        let list = ItemList(name: "Cheltuieli \(Date())")
                        spendingVM.save(list: list)
                    } label: {
                        Text("Create list")
                    }
                }
            }
        }
    }
    
    
    private func delete(list: ItemList) {
            let moc = PersistenceManager.persistentContainer.newBackgroundContext()
            let fetchRequest: NSFetchRequest<CDList>
            fetchRequest = CDList.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id = %@", list.id)
            let listsToDelete = try! moc.fetch(fetchRequest)
            for list in listsToDelete {
                moc.delete(list)
                do {
                    try moc.saveIfNeeded()
                    spendingVM.fetchLists()
                } catch {
                    print(error)
                }
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
