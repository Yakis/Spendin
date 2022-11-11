//
//  ShareListView.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 12/07/2022.
//

import SwiftUI

struct ShareListView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    var list: ItemList
    @Binding var showSharingList: Bool
    @Binding var showShareSheet: Bool
    
    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle.badge.plus")
                .symbolRenderingMode(.hierarchical)
                .font(.system(size: 60))
                .foregroundColor(AdaptColors.theOrange)
                .opacity(0.7)
            List {
                Section {
                    if list.users.count > 1 {
                        ForEach(list.users, id: \.id) { participant in
                            let role = participant.isOwner ? " (Owner)" : " (Invitee)"
                            let title = participant.email == KeychainItem.currentUserEmail ? "You" : participant.email
                            Text(title + role)
                                .font(.caption2)
                                .fontWeight(participant.isOwner ? .semibold : .light)
                                .foregroundColor(.gray)
                        }
                    }
                } header: {
                    Text("Already shared with:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }
                Section {
                    Toggle("Read only", isOn: $spendingVM.readOnly)
                        .tint(AdaptColors.theOrange)
                    Button {
                        Task {
                            try! await spendingVM.shorten()
                            showShareSheet = true
                            showSharingList = false
                        }
                    } label: {
                        Text("Share url")
                            .fontWeight(.bold)
                    }
                    .buttonStyle(.borderless)
                    .tint(AdaptColors.theOrange)
                } header: {
                    Text("Sharing \(list.name) \(list.users.count > 1 ? "again" : "")")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .frame(maxHeight: .infinity)
    }
    
    
    
}
