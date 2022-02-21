//
//  ListsView.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 14/11/2021.
//

import SwiftUI
import CoreData
import CloudKit


struct SpendingsView: View {
    
    var body: some View {
        PageView()
    }
    
}


struct PageView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: CDList.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CDList.created, ascending: true)])
    var lists: FetchedResults<CDList>
    
    
    @FetchRequest(entity: CDItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CDItem.date, ascending: true)])
    var items: FetchedResults<CDItem>
    
    
    @EnvironmentObject var spendingVM: SpendingVM
    @State private var currentIndex: Int?
    @State private var participants: Dictionary<NSManagedObject, [ShareParticipant]> = [:]
    @State private var size: CGSize = .zero
    @State private var showCreateNewListView = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                if lists.isEmpty {
                    VStack {
                        let image = Image(systemName: "plus.circle.fill")
                        Text("Nothing here, you can add a list from the \(image) button")
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .opacity(0.5)
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: [GridItem.init(.fixed(100), spacing: 10)],
                            spacing: 16
                        ) {
                            ForEach(lists, id: \.id) { list in
                                NavigationLink {
                                    DetailedListView(list: list, participants: participants) {
                                        delete(list: spendingVM.currentList!)
                                    }
                                } label: {
                                    ListCell(list: list, geometry: geometry)
                                }
                            }
                        }
                        .onAppear {
                            if spendingVM.currentList == nil {
                                spendingVM.currentList = lists.first
                            }
                        }
                        .onChange(of: items.filter { $0.list?.objectID == spendingVM.currentList?.objectID }) { newValue in
                            print("ITEMS CHANGED!")
                            spendingVM.calculateSpendings(list: spendingVM.currentList)
                        }
                    }
                }
            }
            .navigationTitle("Lists")
            .sheet(isPresented: $showCreateNewListView) {
                
            } content: {
                CreateNewListView()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showCreateNewListView.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
        }
    }
    
    
    private func delete(list: CDList) {
        managedObjectContext.delete(list)
        do {
            try managedObjectContext.saveIfNeeded()
        } catch {
            print("Error deleting list: ", error)
        }
    }
    
    
    
}




struct ListCell: View {
    
    var list: CDList
    var geometry: GeometryProxy
    
    var body: some View {
        HStack {
            Text(list.title ?? "")
                .font(.title3)
                .fontWeight(.bold)
                .padding(10)
            Spacer()
            Text("\(list.items?.count ?? 0) items")
                .font(.caption)
                .fontWeight(.light)
                .padding(10)
        }
        .frame(height: 100)
        .frame(minWidth: geometry.size.width)
        .background(AdaptColors.container)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    
}


