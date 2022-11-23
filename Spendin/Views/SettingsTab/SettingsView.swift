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
    
    @State private var menus = ["Suggestions", "Currencies"]
    @State private var path: [String] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section(header: Text("Account settings")) {
                    NavigationLink(value: "Account") {
                        Label("Account", systemImage: "person")
                    }
                }
                Section(header: Text("Content settings")) {
                    ForEach(menus, id: \.self) { menu in
                        NavigationLink(value: menu) {
                            labelFor(menu: menu)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationDestination(for: String.self) { menu in
                switch menu {
                case "Account": AccountView(message: $message, showAuthentication: $showAuthentication)
                case "Suggestions": SuggestionsView().environmentObject(spendingVM)
                case "Currencies": CurrenciesView().environmentObject(spendingVM)
                default:
                    Text("Error")
                }
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
            .navigationTitle(Text("Settings"))
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    @ViewBuilder
    private func labelFor(menu: String) -> some View {
        switch menu {
        case "Suggestions": Label("Suggestions", systemImage: "rectangle.and.pencil.and.ellipsis")
        case "Currencies": Label("Currencies", systemImage: "dollarsign.circle")
        default: Label("", systemImage: "")
        }
    }
    
    
}

