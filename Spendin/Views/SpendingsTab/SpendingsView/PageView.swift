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
    
    @EnvironmentObject var spendingVM: SpendingVM
    @State private var showDetailedList = false
    @State private var currentIndex: Int?
    @State private var participants: Dictionary<NSManagedObject, [ShareParticipant]> = [:]
    @State private var size: CGSize = .zero
    @State private var showCreateNewListView = false
    
    var body: some View {
        if showDetailedList {
            DetailedListView(list: spendingVM.currentList!, participants: participants, showDetailedList: $showDetailedList) {
                delete(list: spendingVM.currentList!)
                withAnimation {
                    showDetailedList = false
                }
            }
        } else {
            NavigationView {
                VStack {
                    if lists.isEmpty {
                        let image = Image(systemName: "plus.circle.fill")
                        Text("Nothing here, you can add a list from the \(image) button")
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .opacity(0.5)
                    } else {
                        CardListView(participants: $participants, showDetailedList: $showDetailedList)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .sheet(isPresented: $showCreateNewListView) {
                    spendingVM.currentIndex = lists.isEmpty ? 0 : lists.count - 1
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
    }
    
    
    private func delete(list: CDList) {
        managedObjectContext.delete(list)
        do {
            try managedObjectContext.saveIfNeeded()
            if spendingVM.currentIndex != 0 {
                spendingVM.currentIndex -= 1
            }
        } catch {
            print("Error deleting list: ", error)
        }
    }
    
    
}



