//
//  SettingsView.swift
//  Spendtrack
//
//  Created by Mugurel Moscaliuc on 10/07/2020.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    @EnvironmentObject var authService: AuthService
    @State private var message = ""
    @State private var showAuthentication = false
    
    var body: some View {
        VStack {
            Text(message)
                .padding()
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
                Text(authService.isAuthenticated ? "LogOut" : "LogIn")
                    .padding([.leading, .trailing], 16)
                    .padding([.top, .bottom], 8)
            }.buttonStyle(.bordered)
                        Text("Delete suggestions")
                            .padding()
                        Button {
                            spendingVM.deleteSuggestions()
                        } label: {
                            Text("Delete")
                        }.buttonStyle(.borderedProminent)
        }
        .onAppear {
            message = authService.isAuthenticated ? "You're logged in: \(authService.userEmail)" : "Logged out, please log in."
        }
        .onChange(of: authService.isAuthenticated, perform: { isAuthenticated in
            if isAuthenticated {
                showAuthentication = false
                message = "You're logged in: \(authService.userEmail)"
            }
        })
        .sheet(isPresented: $showAuthentication) {
            CloseableView {
                AuthenticationView()
            }
        }
    }
}

