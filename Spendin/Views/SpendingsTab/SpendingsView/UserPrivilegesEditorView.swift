//
//  UserPrivilegesEditorView.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 14/07/2022.
//

import SwiftUI

struct UserPrivilegesEditorView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var spendingVM: SpendingVM
    var list: ItemList
    @Binding var invitee: UserDetails?
    @State private var readOnly = false
    @State private var showStopSharingConfirmation = false
    
    var body: some View {
        if let user = invitee {
            VStack(alignment: .center) {
                Image(systemName: "person.crop.circle.badge.plus")
                    .symbolRenderingMode(.hierarchical)
                    .font(.system(size: 60))
                    .foregroundColor(AdaptColors.theOrange)
                    .opacity(0.7)
                List {
                    Section {
                        Toggle("Read only", isOn: $readOnly)
                            .tint(AdaptColors.theOrange)
                        if user.readOnly != readOnly {
                            Button {
                                let newPrivileges = UserPrivileges(id: user.id, readOnly: readOnly)
                                spendingVM.update(user: newPrivileges, for: list.id)
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Text("Update privileges")
                            }
                            .buttonStyle(.borderless)
                            .tint(AdaptColors.theOrange)
                        }
                    } header: {
                        let username = user.email.split(separator: "@")
                        Text("Edit <\(String(username.first!))@> privileges for \(list.name)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                    }
                    Section {
                        Button(role: .destructive) {
                            showStopSharingConfirmation = true
                        } label: {
                            Text("Stop sharing")
                        }
                        .buttonStyle(.bordered)
                        .tint(AdaptColors.theOrange)
                    } header: {
                        Text("Stop sharing the list")
                    }
                }
            }
            .frame(maxHeight: .infinity)
            .onAppear {
                readOnly = user.readOnly
            }
            .alert("Warning", isPresented: $showStopSharingConfirmation) {
                Button("Cancel", role: .cancel, action: {})
                Button("Confirm", role: .destructive, action: {
                    spendingVM.stopSharing(user: user.id, from: list.id)
                    invitee = nil
                    presentationMode.wrappedValue.dismiss()
                })
            } message: {
                Text("Are you sure you want to stop sharing \(list.name) with \(invitee!.email)?")
            }
        } else {
            Text("NO USER!!!!!!!")
                .frame(maxHeight: .infinity)
        }
    }
    
}
