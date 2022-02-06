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
    
    
    @EnvironmentObject var spendingVM: SpendingVM
    @State private var showDetailedList = false
    @State private var currentIndex: Int?
    @State private var participants: Dictionary<NSManagedObject, [ShareParticipant]> = [:]
    @State private var size: CGSize = .zero
    @State private var showNewListView = false
    
    var body: some View {
        if showDetailedList {
            DetailedListView(list: spendingVM.currentList!, participants: participants, showDetailedList: $showDetailedList) {
                delete(list: spendingVM.currentList!)
                withAnimation {
                    showDetailedList = false
                }
            }
        } else {
            CardListView(participants: $participants, showNewListView: $showNewListView, showDetailedList: $showDetailedList)
//                .onAppear {
//                    spendingVM.fetchLists()
//                }
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



