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
import UIKit
import CoreImage.CIFilterBuiltins

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
    @State private var showInvalidQRAlert = false
    @State private var showQRCodeScanner = false
    @State private var showSharingList = false
    @State private var showEditSharingView = false
    @State private var showShareSheet = false
    
    var list: ItemList
    
    var body: some View {
        if let currentUser = list.users.filter({ user in
            print("USER===\(user)")
            print(KeychainItem.currentUserEmail)
            return user.email == KeychainItem.currentUserEmail
        }).first {
            ZStack {
                VStack(alignment: .leading) {
                    ItemsView(showModal: $showModal, isUpdate: $isUpdate, isReadOnly: currentUser.readOnly)
                    TotalBottomView(showModal: $showModal, isUpdate: $isUpdate, isReadOnly: currentUser.readOnly)
                        .environmentObject(spendingVM)
                }
                .background(AdaptColors.container)
                .onAppear {
                    spendingVM.currentListIndex = spendingVM.lists.firstIndex(of: list)!
                }
                ProgressView("Syncing data...").opacity(spendingVM.isLoading ? 1 : 0)
            }
            .sheet(isPresented: $showShareSheet, onDismiss: {
                spendingVM.readOnly = true
            }, content: {
                ShareSheet(activityItems: ["Sharing <\(list.name)> list.", spendingVM.shortenedURL], applicationActivities: nil, callback: { activityType, completed, returnedItems, error in
                    if completed && error == nil {
                        showShareSheet = false
                    }
                })
            })
            .sheet(isPresented: $showSharingList, content: {
                CloseableView {
                    ShareListView(list: list, showSharingList: $showSharingList, showShareSheet: $showShareSheet)
                }
            })
            .sheet(isPresented: $showEditSharingView, content: {
                CloseableView {
                    EditSharingView(list: list)
                }
            })
            .navigationTitle(list.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            showSharingList = true
                        } label: {
                            Label("Share list", systemImage: "square.and.arrow.up")
                                .foregroundColor(currentUser.isOwner ? AdaptColors.theOrange : Color.gray)
                        }.disabled(!currentUser.isOwner)
                        Button {
                            showEditSharingView = true
                        } label: {
                            Label("Manage permissions", systemImage: "person.crop.circle.badge.checkmark")
                                .foregroundColor((!currentUser.isOwner || list.users.count == 1) ? Color.gray : AdaptColors.theOrange)
                        }.disabled(!currentUser.isOwner || list.users.count == 1)
                    } label: {
                        Image(systemName: "person.crop.circle.fill")
                            .foregroundColor((!currentUser.isOwner) ? Color.gray : AdaptColors.theOrange)
                    }
                }
            }
        } else {
            Text("Shit happened")
        }
    }
    
    
}
