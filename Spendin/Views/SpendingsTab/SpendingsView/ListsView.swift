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
    @State private var selectedIndex = 0
    @State private var participants: Dictionary<NSManagedObject, [ShareParticipant]> = [:]
    
    
    var body: some View {
        List {
            ForEach(0..<lists.count, id: \.self) { index in
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(lists[index].title ?? "No name")
                            .font(.title3)
                            .fontWeight(.bold)
                            .lineLimit(2)
                            .padding(5)
                        Text("Items: \(lists[index].items?.count ?? 0)")
                            .font(.callout)
                            .padding(5)
                    }
                    ShareInfo(index: index, participants: $participants)
                }
                .onTapGesture {
                    spendingVM.currentList = lists[index]
                    selectedIndex = index
                    spendingVM.calculateSpendings()
                    showDetailedList = true
                }
            }
            .onDelete {
                delete(list: lists[$0.first!])
            }
        }
        .onAppear(perform: {
            lists.forEach { list in
                participants[list] = PersistenceManager.participants(for: list)
            }
        })
        .onChange(of: lists.shuffled()) { newValue in
            spendingVM.calculateSpendings()
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
    
    private func delete(list: CDList) {
        managedObjectContext.delete(list)
        do {
            try managedObjectContext.saveIfNeeded()
        } catch {
            print(error)
        }
    }
    
    
}

struct ShareInfo: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: CDList.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CDList.created, ascending: true)])
    var lists: FetchedResults<CDList>
    
    var index: Int
    @Binding var participants: Dictionary<NSManagedObject, [ShareParticipant]>
    @State private var showAlert = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                ForEach(participants[lists[index]] ?? [], id: \.participantID) { participant in
                    if !participant.firstName.isEmpty {
                        HStack {
                            Image(systemName: participant.isCurrentUser ? "person.fill" : "person")
                                .font(.caption)
                                .foregroundColor(participant.isCurrentUser ? .green : .gray)
                                .padding(5)
                            Text(participant.firstName + " " + (participant.userID.contains("defaultOwner") ? "(owner)" : "(\(participant.permission.name))"))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            Spacer()
            //            Button {
            //                showAlert = true
            //            } label: {
            //                Image(systemName: "xmark.icloud.fill")
            //                    .font(.title)
            //            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Warning"),
                message: Text("Are you shure you want to stop sharing this list?"),
                primaryButton: .destructive(Text("Stop Sharing")) {
                    // Need to figure out how to stop sharing
                    PersistenceManager.stopSharing(for: lists[index])
                },
                secondaryButton: .cancel()
            )
        }
    }
}
