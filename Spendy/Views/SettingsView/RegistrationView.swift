//
//  RegistrationView.swift
//  Spendy
//
//  Created by Mugurel on 26/07/2020.
//

import SwiftUI

struct RegistrationView: View {
    
    @EnvironmentObject var viewModel: SettingsVM
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatPassword: String = ""
    
    var body: some View {
        VStack {
            Image(systemName: "person.crop.square.fill.and.at.rectangle").font(.largeTitle).padding()
            Text("Registration")
                .font(.largeTitle)
            Spacer().frame(height: 50)
            TextField("name", text: $name)
                .frame(height: 30)
                .padding()
                .background(AdaptColors.textField)
                .clipShape(Capsule())
            TextField("email", text: $email)
                .frame(height: 30)
                .keyboardType(.emailAddress)
                .padding()
                .background(AdaptColors.textField)
                .clipShape(Capsule())
            SecureField("password", text: $password)
                .frame(height: 30)
                .padding()
                .background(AdaptColors.textField)
                .clipShape(Capsule())
            SecureField("repeat password", text: $repeatPassword)
                .frame(height: 30)
                .padding()
                .background(AdaptColors.textField)
                .clipShape(Capsule())
            Spacer().frame(height: 50)
            Button("Register") {
                let authObject = AuthObject(name: name, email: email, password: password, repeatPassword: repeatPassword)
                viewModel.register(with: authObject) { (data, error) in
                    guard let data = data else {
                        print(error!)
                        return
                    }
                    presentationMode.wrappedValue.dismiss()
                    // Use data
                    print(data)
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

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
