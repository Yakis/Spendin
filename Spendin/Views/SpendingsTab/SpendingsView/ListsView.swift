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
    @State private var selectedList: CDList?
    @State private var showDetailedList = false
    @State private var currentIndex: Int?
    @State private var participants: Dictionary<NSManagedObject, [ShareParticipant]> = [:]
    @State private var size: CGSize = .zero
    @State private var showNewListView = false
    
    var body: some View {
        if showDetailedList {
            SpendingsViewContent(list: spendingVM.currentList!, participants: participants, showDetailedList: $showDetailedList) {
                delete(list: spendingVM.currentList!)
            }
        } else {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                TabView {
                    ForEach(lists, id: \.objectID) { list in
                        VStack(alignment: .leading) {
                            Text(list.title ?? "")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding()
                            ShareInfoView(list: list, participants: participants)
                                .opacity(0.8)
                            VStack(alignment: .leading) {
                            ForEach(list.itemsArray, id: \.objectID) { item in
                                HStack {
                                Text(item.name ?? "")
                                    .font(.caption)
                                    Spacer()
                                Text("£ \(String(format: "%.2f", item.amount))")
                                    .font(.caption)
                                }
                            }
                                Text("Amount left: \(String(format: "%.2f", spendingVM.total))")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(.top, 5)
                            }
                            .shadow(radius: 2)
                            .padding()
                            Spacer()
                        }
                        .frame(width: size.width / 1.3, height: size.height / 1.3, alignment: .leading)
                        .background(AdaptColors.theOrange)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .onAppear {
                            guard let indexOfList = lists.firstIndex(of: list) else {return}
                            spendingVM.currentList = list
                            currentIndex = indexOfList
                        }
                        .onTapGesture {
                            withAnimation {
                                showDetailedList = true
                            }
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
                    }.onAppear {
                        currentIndex = lists.count
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
            .onChange(of: currentIndex) { newValue in
                spendingVM.calculateSpendings()
            }
            .sheet(isPresented: $showNewListView) {
                
            } content: {
                NewListView()
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



