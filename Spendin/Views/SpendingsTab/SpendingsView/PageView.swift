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
    
    @EnvironmentObject var spendingVM: SpendingVM
    @State private var currentIndex: Int?
    @State private var size: CGSize = .zero
    @State private var showCreateNewListView = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                if spendingVM.lists.isEmpty {
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
                            ForEach(spendingVM.lists, id: \.id) { list in
                                NavigationLink {
                                    DetailedListView(list: list) {
                                        delete(list: spendingVM.currentList!)
                                    }
                                } label: {
                                    ListCell(list: list, items: spendingVM.currentListItems, geometry: geometry)
                                }
                            }
                        }
                        .onAppear {
                            if spendingVM.currentList == nil {
                                spendingVM.currentList = spendingVM.lists.first
                            }
                                spendingVM.lists.forEach { list in
                            }
                        }
                        .onChange(of: spendingVM.currentListItems) { newValue in
                            spendingVM.calculateSpendings()
                        }
                    }.padding(.top, 10)
                }
            }
            .navigationTitle("Lists")
            .sheet(isPresented: $showCreateNewListView) {
                
            } content: {
                CreateNewListView()
            }
            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading, content: {
//                    Text("Lists")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                        .multilineTextAlignment(.leading)
//                        .frame(alignment: .leading)
//                        .padding(.top, 30)
//                })
                
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
    
    
    private func delete(list: ItemList) {
        let oldIndex = spendingVM.lists.firstIndex(of: list)
        
    }
    
    
    
}




struct ListCell: View {
    
    var list: ItemList
    var items: [Item]
    var geometry: GeometryProxy
    
    var body: some View {
        HStack {
            Text(list.name)
                .font(.title3)
                .fontWeight(.bold)
                .padding(10)
            Spacer()
            Text("\(items.count) items")
                .font(.caption)
                .fontWeight(.light)
                .padding(10)
        }
        .frame(height: 100)
        .frame(minWidth: geometry.size.width - 32)
        .background(AdaptColors.container)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding([.leading, .trailing], 16)
    }
    
    
}


