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
    @State private var showDeleteListAlert = false
    @State private var showInvalidQRAlert = false
    @State private var showQRCodeScanner = false
    @State private var showSharingList = false
    @State private var qrValue = ""
    @State private var invitee: UserDetails? = nil
    @State private var message: String = ""
    var list: ItemList
    var deleteAction: () -> ()
    
    private var currentUser: UserDetails {
        return list.users.filter { user in
            user.email == KeychainItem.currentUserEmail
        }.first!
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                if list.users.count > 1 {
                    Text("Participants:")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .padding([.leading, .trailing], 16)
                        .padding(.bottom, 2)
                        ForEach(list.users, id: \.id) { participant in
                            let role = participant.isOwner ? " (Owner)" : " (Invitee)"
                            let title = participant.email == KeychainItem.currentUserEmail ? "You" : participant.email
                            Text(title + role)
                                .font(.caption2)
                                .fontWeight(participant.isOwner ? .semibold : .light)
                                .foregroundColor(.gray)
                                .padding([.leading, .trailing], 16)
                        }
                }
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
        .alert(isPresented: $showDeleteListAlert) {
            Alert(
                title: Text("Warning"),
                message: Text("Are you sure you want to delete this list?"),
                primaryButton: .destructive(Text("Delete")) {
                    deleteAction()
                },
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $showQRCodeScanner, content: {
            VStack {
                Text(qrValue)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                ScannerView(value: $qrValue)
                    .onChange(of: qrValue) { newValue in
                        if !newValue.isEmpty {
                            showQRCodeScanner = false
                            qrValue = ""
                            guard let data = newValue.data(using: String.Encoding.utf8) else { return }
                            let existingUsers = list.users.map { $0.email }
                            guard let decodedUser = try? JSONDecoder().decode(UserDetails.self, from: data) else {
                                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                                    message = "The QR code is invalid."
                                    showInvalidQRAlert = true
                                }
                                return
                            }
                            guard !existingUsers.contains(decodedUser.email) else {
                                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                                    message = "User is the owner of the list, or is already invited."
                                    showInvalidQRAlert = true
                                }
                                return
                            }
                            self.invitee = decodedUser
                            showSharingList = true
                        }
                    }
            }
        })
        .sheet(isPresented: $showSharingList, content: {
            if let invitee = invitee {
                CloseableView {
                    ShareListView(list: list, invitee: invitee)
                }
            }
        })
        .navigationTitle(list.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showDeleteListAlert = true
                } label: {
                    Image(systemName: "trash.fill")
                        .foregroundColor(currentUser.readOnly ? Color.gray : AdaptColors.theOrange)
                }.disabled(currentUser.readOnly)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showQRCodeScanner = true
                } label: {
                    Image(systemName: "qrcode.viewfinder")
                        .foregroundColor(AdaptColors.theOrange)
                }
            }
        }
        .alert(Text("Error"), isPresented: $showInvalidQRAlert, actions: {
            Button {
                showInvalidQRAlert = false
                message = ""
            } label: {
                Text("Dismiss")
            }
            Button {
                showInvalidQRAlert = false
                showQRCodeScanner = true
                message = ""
            } label: {
                Text("Retry")
            }
        }, message: {
            Text(message)
        })
    }
    
    
}


struct ShareListView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var spendingVM: SpendingVM
    var list: ItemList
    var invitee: UserDetails
    @State private var readOnly = false
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "person.crop.circle.badge.plus")
                .symbolRenderingMode(.hierarchical)
                .font(.system(size: 60))
                .foregroundColor(AdaptColors.theOrange)
                .opacity(0.7)
            Spacer()
            Text("Sharing **\(list.name)** with **\(invitee.email)**")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding([.leading, .trailing], 30)
            Spacer()
            Toggle("Read only", isOn: $readOnly)
                .tint(AdaptColors.theOrange)
                .padding([.leading, .trailing], 50)
                Spacer()
            Button {
                let newInvitee = UserDetails(id: invitee.id, isOwner: false, readOnly: readOnly, email: invitee.email)
                spendingVM.invite(user: newInvitee, to: list)
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Share")
                    .padding(5)
            }
            .buttonStyle(.borderedProminent)
            .tint(AdaptColors.theOrange)
            .padding(8)
            Spacer()
        }
        .frame(maxHeight: .infinity)
    }
    
}
