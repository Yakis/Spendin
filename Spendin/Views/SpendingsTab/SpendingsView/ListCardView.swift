//
//  ListCardView.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 23/11/2021.
//

import SwiftUI
import CoreData


struct ListCardView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    @FetchRequest(entity: CDList.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CDList.created, ascending: true)])
    var lists: FetchedResults<CDList>
    @Binding var participants: Dictionary<NSManagedObject, [ShareParticipant]>
    @State private var currentIndex: Int? = 0
    @Binding var showNewListView: Bool
    @Binding var showDetailedList: Bool
    
    var body: some View {
        GeometryReader { proxy in
            TabView(selection: $currentIndex) {
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
                    .frame(width: proxy.size.width / 1.3, height: proxy.size.height / 1.3, alignment: .leading)
                    .background(.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .tag(lists.firstIndex(of: list))
                    .onTapGesture {
                        withAnimation {
                            spendingVM.currentList = lists[currentIndex ?? 0]
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
                    Text("or import from file")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .opacity(0.5)
                        .padding()
                    Button {
                        importList()
                    } label: {
                        Image(systemName: "arrow.up.doc.fill")
                            .font(.title)
                    }

                }.tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
            .sheet(isPresented: $showNewListView) {
                self.currentIndex = lists.count - 1
            } content: {
                NewListView()
            }
            .onAppear(perform: {
                lists.forEach { list in
                    participants[list] = PersistenceManager.participants(for: list)
                }
            })
            .onChange(of: currentIndex) { newValue in
                print("Current index: \(newValue!)")
                spendingVM.currentList = lists[newValue!]
                spendingVM.calculateSpendings()
            }
        }
    }
    
    
    private func importList() {
        guard let driveURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") else { return }
        let fileURL = driveURL.appendingPathComponent("Feb-March" + "." + "json")
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let list = try decoder.decode(ItemList.self, from: data)
//            print(list.items)
            Task.init {
                spendingVM.save(list: list)
                for item in list.items {
                    spendingVM.save(item: item)
                }
            }
        } catch {
            print("Error importing json: \(error)")
        }
    }
    
    
}
