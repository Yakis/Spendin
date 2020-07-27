//
//  LoginView.swift
//  Spendy
//
//  Created by Mugurel on 26/07/2020.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var viewModel: SettingsVM
    @Environment(\.presentationMode) var presentationMode
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack() {
            Image(systemName: "key").font(.largeTitle).padding()
            Text("Login")
                .font(.largeTitle)
            Spacer().frame(height: 50)
            TextField("email", text: $email)
                .frame(height: 30)
                .padding()
                .background(AdaptColors.textField)
                .clipShape(Capsule())
                .keyboardType(.emailAddress)
            SecureField("password", text: $password)
                .frame(height: 30)
                .padding()
                .background(AdaptColors.textField)
                .clipShape(Capsule())
            Spacer().frame(height: 50)
            Button("Login") {
                viewModel.login(email: email, password: password) { (token, error) in
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .frame(width: UIScreen.main.bounds.width / 2, height: 30)
            .padding()
            .background(AdaptColors.theOrange)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }.padding()
    }
    
    
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
