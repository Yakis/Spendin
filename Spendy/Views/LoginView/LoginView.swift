//
//  LoginView.swift
//  Spendy
//
//  Created by Mugurel on 30/10/2020.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    
    
    @EnvironmentObject var siwaService: SiwAService
    @State private var currentNonce: String?
    
    var body: some View {
            VStack(alignment: .center) {
                Spacer()
                Text("Welcome!")
                    .font(.title)
                Text("In order to safely save your data, you need to be authenticated, just press the Sign In button and you're all set.")
                    .frame(width:  UIScreen.main.bounds.width - 60, height: 100, alignment: .center)
                    .font(.headline)
                    .padding([.top, .bottom], 20)
                SignInWithAppleButton(.signIn) { request in
                    request.requestedScopes = [.fullName, .email]
                } onCompletion: { result in
                    switch result {
                    case .success(let authResult):
                        siwaService.login(authorization: authResult, completion: { result in

                        })
                        
                    case .failure(let error):
                        print(error)
                    }
                    
                }
                .signInWithAppleButtonStyle(.whiteOutline)
                .frame(width: UIScreen.main.bounds.width - 60, height: 50, alignment: .center)
                .padding(.bottom, 20)
                ProgressView()
                    .opacity(siwaService.isLoading ? 1 : 0)
                Spacer()
            }
    }
    
    
    
    
    
    func handleAuth(authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            let token = String(data: appleIDCredential.authorizationCode!, encoding: String.Encoding.utf8)
            let jwt = appleIDCredential.identityToken
            print("UID: \(userIdentifier)")
            print("Full name: \(fullName ?? PersonNameComponents())")
            print("Email: \(email ?? "[email]")")
            print("JWT: \(jwt ?? Data())")
            print("Token: \(token ?? "[token]")")
        default:
            break
        }
    }
    
    
    
    
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
