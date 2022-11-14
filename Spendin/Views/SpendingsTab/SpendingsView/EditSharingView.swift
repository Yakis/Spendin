//
//  EditSharingView.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 14/07/2022.
//

import SwiftUI

struct EditSharingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var spendingVM: SpendingVM
    var list: ItemList
    @State private var readOnly = false
    @State private var showPrivilegeEditor = false
    @State private var userToEdit: UserDetails?
    
    var body: some View {
        VStack(alignment: .center) {
            List {
                ForEach(list.users, id: \.id) { user in
                    if !user.isOwner {
                        HStack {
                            Text(user.name ?? user.email)
                                .fontWeight(.semibold)
                                .padding()
                            Spacer()
                            Text(user.readOnly ? "read only" : "full access" )
                                .fontWeight(.light)
                                .padding()
                        }
                        .onTapGesture {
                            userToEdit = user
                            showPrivilegeEditor = true
                            print("User to edit: \(userToEdit!.email)")
                        }
                    }
                }
            }
        }
        .frame(maxHeight: .infinity)
        .sheet(isPresented: $showPrivilegeEditor) {
            CloseableView {
                UserPrivilegesEditorView(list: list, invitee: $userToEdit)
            }
        }
    }
    
}
