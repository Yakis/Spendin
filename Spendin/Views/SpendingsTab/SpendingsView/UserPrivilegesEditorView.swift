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
                Spacer()
                Text("Edit **\(user.email)**'s privileges for **\(list.name)**")
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
                HStack {
                    Button(role: .destructive) {
                        showStopSharingConfirmation = true
                    } label: {
                        Text("Stop sharing")
                            .padding(5)
                    }
                    .buttonStyle(.bordered)
                    .tint(AdaptColors.theOrange)
                    .padding(8)
                    Button {
                        let newPrivileges = UserPrivileges(id: user.id, readOnly: readOnly)
                        spendingVM.update(user: newPrivileges, for: list.id)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Update")
                            .padding(5)
                    }
                    .buttonStyle(.bordered)
                    .tint(AdaptColors.theOrange)
                    .padding(8)
                }
                Spacer()
            }
            .frame(maxHeight: .infinity)
            .onAppear {
                readOnly = user.readOnly
            }
            .alert("Warning", isPresented: $showStopSharingConfirmation) {
                Button("Dismiss", role: .cancel, action: {
                    invitee = nil
                })
                Button("Confirm", role: .cancel, action: {
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
