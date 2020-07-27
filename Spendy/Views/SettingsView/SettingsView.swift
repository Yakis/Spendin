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
    
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Button("Register") {
                showRegister.toggle()
            }
            .padding()
            .background(AdaptColors.theOrange)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .sheet(isPresented: $showRegister) {
                RegistrationView()
                    .environmentObject(viewModel)
                    .background(AdaptColors.container)
                    .edgesIgnoringSafeArea(.all)
                
            }
            Spacer().frame(height: 50)
            Text("Have an account?")
            Spacer().frame(height: 20)
            Button("Login") {
                showLogin.toggle()
            }
            .foregroundColor(.blue)
            .sheet(isPresented: $showLogin) {
                LoginView()
                    .environmentObject(viewModel)
                    .background(AdaptColors.container)
                    .edgesIgnoringSafeArea(.all)
            }
            Spacer()
        }
        .padding()
        .edgesIgnoringSafeArea([.leading, .trailing])
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

