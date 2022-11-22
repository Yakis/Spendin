//
//  AccountView.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 22/11/2022.
//

import SwiftUI

struct AccountView: View {
    
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var spendingVM: SpendingVM
    @Binding var message: String
    @Binding var showAuthentication: Bool
    
    var body: some View {
        List {
            Section {
                Text(message)
                Button {
                    if authService.isAuthenticated {
                        authService.logout { message in
                            self.message = message
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                                self.message = authService.isAuthenticated ? "You're logged in: \(authService.userEmail)" : "Logged out, please log in."
                            }
                        }
                    } else {
                        showAuthentication = true
                    }
                } label: {
                    Text(authService.isAuthenticated ? "Logout" : "Login")
                }.buttonStyle(.borderless)
            } header: {
                Text(spendingVM.currentUser?.name ?? authService.userEmail)
            }.headerProminence(.standard)
        }
        .listStyle(.insetGrouped)
        .navigationTitle(Text("Account"))
        .navigationBarTitleDisplayMode(.large)
    }
    
}
