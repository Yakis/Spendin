//
//  SettingsView.swift
//  Spendtrack
//
//  Created by Mugurel Moscaliuc on 10/07/2020.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.spendingVM) private var spendingVM
    @State private var message = ""
    @State private var showAuthentication = false
    
    @State private var menus = ["Suggestions", "Currencies"]
    @State private var path: [String] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
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
                case "Suggestions": SuggestionsView()
                case "Currencies": CurrenciesView()
                default:
                    Text("Error")
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

