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
            VStack {
                HStack {
                    Spacer().frame(height: 40)
                    Button {
                        showCreateNewListView = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                            .foregroundColor(AdaptColors.theOrange)
                    }
                }
                .frame(maxHeight: 80, alignment: .top)
                .padding([.top, .trailing], 20)
                if lists.isEmpty {
                    Text("No list")
                        .font(.title)
                        .opacity(0.5)
                } else {
                    CardListView(participants: $participants, showDetailedList: $showDetailedList)
                        .offset(x: 0, y: -30)
                }
            }
            .sheet(isPresented: $showCreateNewListView) {
                spendingVM.currentIndex = lists.isEmpty ? 0 : lists.count - 1
            } content: {
                CreateNewListView()
            }
        }
    }
    
    
    private func delete(list: CDList) {
        managedObjectContext.delete(list)
        do {
            try managedObjectContext.saveIfNeeded()
            if spendingVM.currentIndex != nil && spendingVM.currentIndex != 0 {
                spendingVM.currentIndex! -= 1
            }
        } catch {
            print("Error deleting list: ", error)
        }
    }
    
    
}



