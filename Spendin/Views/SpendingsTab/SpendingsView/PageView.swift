//
//  ListsView.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 14/11/2021.
//

import SwiftUI
import Combine
import UIKit
import CoreImage.CIFilterBuiltins
import SwiftData

struct SpendingsView: View {
    
    var body: some View {
        PageView()
    }
    
}


struct PageView: View {
    
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var spendingVM: SpendingVM
    @State private var currentIndex: Int?
    @State private var size: CGSize = .zero
    @State private var showCreateNewListView = false
    @State private var showDeleteListAlert = false
    @State private var showDeleteRestrictionAlert = false
    @State private var cancellables = Set<AnyCancellable>()
    @State private var listToDelete: ItemList?
    
    @Query private var lists: [ItemList]
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationView {
                ZStack {
                    GeometryReader { geometry in
                        if lists.isEmpty && !spendingVM.isLoading {
                            VStack {
                                let image = Image(systemName: "plus.circle.fill")
                                Text("Nothing here, you can add a list from the \(image) button")
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                                    .opacity(0.5)
                            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            SummaryListView(listToDelete: $listToDelete, showDeleteListAlert: $showDeleteListAlert, showDeleteRestrictionAlert: $showDeleteRestrictionAlert)
                                .onChange(of: spendingVM.currentListItems) { newValue in
                                    spendingVM.calculateSpendings()
                                }
                                .alert("Warning", isPresented: $showDeleteListAlert) {
                                    Button("Cancel", role: .cancel, action: {
                                        showDeleteListAlert = false
                                        listToDelete = nil
                                    })
                                    Button("Delete", role: .destructive, action: { delete(list: listToDelete) })
                                } message: {
                                    Text("Are you sure you want to delete this list?")
                                }
                        }
                    }
                    .navigationTitle("Lists")
                    .sheet(isPresented: $showCreateNewListView) {
                        
                    } content: {
                        CloseableView {
                            CreateNewListView()
                        }
                    }
                    .alert("Warning", isPresented: $showDeleteRestrictionAlert) {
                        Button("Dismiss", role: .cancel, action: {
                            showDeleteRestrictionAlert = false
                            listToDelete = nil
                        })
                    } message: {
                        Text("You don't have the permission to delete this list.")
                    }
                    .toolbar {
                        MainViewToolbar(showCreateNewListView: $showCreateNewListView)
                    }
                    ProgressView("Loading...").opacity((spendingVM.isLoading) ? 1 : 0)
                }
            }
    }
    
    
    private func delete(list: ItemList?) {
        modelContext.delete(object: list!)
    }
    
    
}



struct MainViewToolbar: ToolbarContent {
    
    @Binding var showCreateNewListView: Bool
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
                Button {
                    showCreateNewListView.toggle()
                } label: {
                    Label("New list", systemImage: "plus.circle.fill")
                }
                Button {
                    
                } label: {
                    Label("Import", systemImage: "square.and.arrow.down")
                }
            } label: {
                Image(systemName: "plus.circle.fill")
            }
        }
    }
}



struct SummaryListView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    @Binding var listToDelete: ItemList?
    @Binding var showDeleteListAlert: Bool
    @Binding var showDeleteRestrictionAlert: Bool
    @Query private var lists: [ItemList]
    
    var body: some View {
        List {
            ForEach(lists, id: \.id) { list in
                NavigationLink {
                    DetailedListView(list: list)
                } label: {
                    HStack {
                        Text(list.name)
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(10)
                        Spacer()
                        Text("\(list.items?.count ?? 0) items")
                            .font(.caption)
                            .fontWeight(.light)
                            .padding(10)
                    }
                }
            }
            .onDelete { index in
                for i in index {
                    listToDelete = lists[i]
                    if let list = listToDelete {
                        showDeleteListAlert = true
                    }
                }
            }
        }
    }
    
}
