//
//  SettingsView.swift
//  Spendtrack
//
//  Created by Mugurel Moscaliuc on 10/07/2020.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var viewModel: SettingsVM
    @State private var showRegister = false
    @State private var showLogin = false
    @State private var username: String = ""
    
    
    var body: some View {
        VStack {
            if viewModel.userToken.isEmpty {
            RegisterLoginButtonsView(showRegister: $showRegister, showLogin: $showLogin).environmentObject(viewModel)
            } else {
                Text("You're logged in as \(username)")
            }
    }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}



