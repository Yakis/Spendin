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
}



struct SpendingsView: View {
    
    var body: some View {
        PageView()
    }
    
    
}



struct DetailedListView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var spendingVM: SpendingVM
    @State var showModal: Bool = false
    @State var isUpdate: Bool = false
    @State private var isLoading: Bool = true
    @State private var cancellable: AnyCancellable?
    @State private var showAlert = false
    var list: CDList
    var participants: Dictionary<NSManagedObject, [ShareParticipant]>
    @Binding var showDetailedList: Bool
    var deleteAction: () -> ()
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(list.title ?? "")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding()
                    Spacer()
                    Button {
                        withAnimation {
                            showDetailedList = false                            
                        }
                    } label: {
                        Image(systemName: "xmark.circle")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }.padding()
                HStack(alignment: .center) {
                    ShareInfoView(list: list, participants: participants)
                    Spacer()
                    CloudKitSharingButton(list: list.objectID)
                        .frame(width: 50, height: 50, alignment: .center)
                    Button {
                        print("Export")
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
                ItemsView(showModal: $showModal, isUpdate: $isUpdate, list: list)
                TotalBottomView(showModal: $showModal, isUpdate: $isUpdate)
                    .environmentObject(spendingVM)
                
            }
            .background(AdaptColors.container)
            ProgressView("Syncing data...").opacity(spendingVM.isLoading ? 1 : 0)
        }
        .onAppear {
            UITableViewCell.appearance().backgroundColor = UIColor.init(named: "CellContainer")
            UITableView.appearance().backgroundColor = UIColor.init(named: "Container")
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
    }
    
    
    
    private func exportJson() {
        let encoder = JSONEncoder()
        do {
            let encodableList = ItemList(from: list)
            let jsonObject = try encoder.encode(encodableList)
            guard let driveURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") else { return }
            let fileURL = driveURL.appendingPathComponent(encodableList.name + "." + "json")
            try jsonObject.write(to: fileURL)
        } catch {
            print("Error encoding json: \(error)")
        }
    }
    
    
    
}


