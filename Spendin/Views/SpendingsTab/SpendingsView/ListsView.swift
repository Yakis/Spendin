//
//  ListsView.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 14/11/2021.
//

import SwiftUI
import CoreData
import CloudKit

struct ListsView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: CDList.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CDList.created, ascending: true)])
    var lists: FetchedResults<CDList>
    
    @EnvironmentObject var spendingVM: SpendingVM
    @State private var selectedList: ItemList?
    @State private var showDetailedList = false
    @State private var currentIndex = 0
    @State private var participants: Dictionary<NSManagedObject, [ShareParticipant]> = [:]
    @State private var size: CGSize = .zero
    @State private var showNewListView = false
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                TabView {
                    ForEach(lists, id: \.objectID) { list in
                        SpendingsViewContent(list: list, participants: $participants, deleteAction: {
                            if !lists.isEmpty {
                                delete(list: list)
                            }
                        })
                            .frame(width: size.width, height: size.height, alignment: .center)
                            .onAppear {
                                spendingVM.currentList = list
//                                currentIndex = index
                                spendingVM.calculateSpendings()
                            }
                    }
                    VStack {
                        Text("Add a new list")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .opacity(0.5)
                            .padding()
                        Button {
                            showNewListView = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(width: size.width, height: size.height, alignment: .center)
            }
            .frame(width: size.width, height: size.height, alignment: .center)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }.readSize(onChange: { size in
            self.size = size
        })
            .onAppear(perform: {
                lists.forEach { list in
                    participants[list] = PersistenceManager.participants(for: list)
                }
            })
//            .onChange(of: lists.count) { newValue in
//                spendingVM.calculateSpendings()
//            }
            .sheet(isPresented: $showNewListView) {
                
            } content: {
                NewListView()
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



