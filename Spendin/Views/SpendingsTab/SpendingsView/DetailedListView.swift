//
//  SpendingsView.swift
//  Spendtrack
//
//  Created by Mugurel Moscaliuc on 10/07/2020.
//

import SwiftUI
import Combine
import CoreData
import CloudKit

enum ItemType: String, CaseIterable, Codable {
    case expense, income
    
    init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawString = try container.decode(String.self)
            
            if let type = ItemType(rawValue: rawString.lowercased()) {
                self = type
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot initialize UserType from invalid String value \(rawString)")
            }
        }
    
}



struct DetailedListView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    @State var showModal: Bool = false
    @State var isUpdate: Bool = false
    @State private var isLoading: Bool = true
    @State private var cancellable: AnyCancellable?
    @State private var showAlert = false
    var list: ItemList
    var deleteAction: () -> ()
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Button {
                        exportJson()
                    } label: {
                        Image(systemName: "arrow.down.doc.fill")
                            .font(.title3)
                            .foregroundColor(.red)
                            .padding()
                    }
                    Button {
                        showAlert = true
                    } label: {
                        Image(systemName: "trash.fill")
                            .font(.title3)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .frame(maxHeight: 50)
                .background(AdaptColors.container)
                ItemsView(showModal: $showModal, isUpdate: $isUpdate)
                TotalBottomView(showModal: $showModal, isUpdate: $isUpdate)
                    .environmentObject(spendingVM)
                
            }
            .background(AdaptColors.container)
            .onAppear {
                spendingVM.currentList = list
            }
            ProgressView("Syncing data...").opacity(spendingVM.isLoading ? 1 : 0)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Warning"),
                message: Text("Are you sure you want to delete this list?"),
                primaryButton: .destructive(Text("Delete")) {
                    deleteAction()
                },
                secondaryButton: .cancel()
            )
        }
        .navigationTitle(list.name)
        .navigationBarTitleDisplayMode(.large)
    }
    
    
    
    private func exportJson() {
        let encoder = JSONEncoder()
        do {
            let jsonObject = try encoder.encode(list)
            guard let driveURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") else { return }
            let fileURL = driveURL.appendingPathComponent(list.name + "." + "json")
            try jsonObject.write(to: fileURL)
        } catch {
            print("Error encoding json: \(error)")
        }
    }
    
    
    
}


