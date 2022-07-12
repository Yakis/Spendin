//
//  ShareListView.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 12/07/2022.
//

import SwiftUI

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
