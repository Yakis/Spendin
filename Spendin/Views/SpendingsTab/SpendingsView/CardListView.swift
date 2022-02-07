//
//  ListCardView.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 23/11/2021.
//

import SwiftUI
import CoreData


struct CardListView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    @FetchRequest(entity: CDList.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CDList.created, ascending: true)])
    var lists: FetchedResults<CDList>
    @Binding var participants: Dictionary<NSManagedObject, [ShareParticipant]>
    
    @Binding var showDetailedList: Bool
    
    var body: some View {
        GeometryReader { proxy in
            TabView(selection: $spendingVM.currentIndex) {
                ForEach(lists, id: \.objectID) { list in
                    CardView(proxy: proxy, currentList: list, participants: $participants, showDetailedList: $showDetailedList)
                        .environmentObject(spendingVM)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
            .onAppear(perform: {
                lists.forEach { list in
                    participants[list] = PersistenceManager.participants(for: list)
                }
            })
            .onChange(of: spendingVM.currentIndex) { newValue in
                print("Current index: \(newValue!)")
                spendingVM.currentList = lists[newValue!]
                spendingVM.calculateSpendings()
            }
        }
    }
    
    
    private func importList() {
        guard let driveURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") else { return }
        let enumerator = FileManager.default.enumerator(atPath: driveURL.path)
        let filePaths = enumerator?.allObjects as! [String]
        let jsonFilePaths = filePaths.filter{$0.contains(".json")}
        for jsonFilePath in jsonFilePaths {
            print(jsonFilePath)
            do {
                let data = try Data(contentsOf: driveURL.appendingPathComponent(jsonFilePath))
                let decoder = JSONDecoder()
                let list = try decoder.decode(ItemList.self, from: data)
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
    
    
}





