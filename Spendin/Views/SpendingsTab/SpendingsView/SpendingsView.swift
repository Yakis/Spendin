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

enum ItemType: String, CaseIterable, Encodable {
    case expense, income
}



struct SpendingsView: View {
    
    var body: some View {
        ListsView()
    }
    
    
}



struct SpendingsViewContent: View {
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
            VStack(alignment: .leading, spacing: 20) {
                HStack {
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
                Text(list.title ?? "")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding()
                HStack(alignment: .center) {
                    ShareInfoView(list: list, participants: participants)
                    Spacer()
                    CloudKitSharingButton(list: list.objectID)
                        .frame(width: 50, height: 50, alignment: .center)
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
                message: Text("Are you shure you want to delete this list?"),
                primaryButton: .destructive(Text("Delete")) {
                    deleteAction()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    
}


