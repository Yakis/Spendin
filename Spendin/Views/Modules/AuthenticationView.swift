//
//  AuthenticationView.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 03/07/2022.
//

import SwiftUI
import AuthenticationServices



struct AuthenticationView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authService: AuthService
    @State private var currentNonce: String?
    
    var body: some View {
        GeometryReader { bounds in
            VStack(alignment: .center) {
                Spacer()
                Text("In order to save a list you need to be authenticated.")
                    .frame(width: bounds.size.width - 60, height: 100, alignment: .center)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding([.top, .bottom], 20)
                    .foregroundColor(isFullScreen(bounds: bounds) ? Color(UIColor.lightText) : Color(UIColor.darkText))
                SignInWithAppleButton(.signIn) { request in
                    request.requestedScopes = [.fullName, .email]
                } onCompletion: { result in
                    switch result {
                    case .success(let authResult):
                        authService.login(authorization: authResult, completion: {
                        })
                    case .failure(let error):
                        print(error)
                    }
                }
                .signInWithAppleButtonStyle(.whiteOutline)
                .frame(width: UIDevice.current.userInterfaceIdiom == .phone ? bounds.size.width - 60 : 300, height: 50, alignment: .center)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)
                Button(action: {
//                    authService.loginWithGoogle()
                }, label: {
                    HStack {
                        Image("googleSignIn").resizable()
                            .frame(width: 14, height: 14, alignment: .center)
                        Text(NSLocalizedString("GoogleSignInButton", comment: ""))
                            .foregroundColor(AdaptColors.container)
                            .font(.custom(Fonts.robotoMedium, size: 18))
                    }
                })
                .frame(width: UIDevice.current.userInterfaceIdiom == .phone ? bounds.size.width - 60 : 300, height: 50, alignment: .center)
                .background(AdaptColors.cellBackground)
                .cornerRadius(5)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)
                ProgressView()
                    .opacity(authService.isLoading ? 1 : 0)
                Spacer()
            }
        }
    }
    
    func isFullScreen(bounds: GeometryProxy) -> Bool {
        return (UIScreen.main.bounds.size.height - bounds.size.height) < (UIScreen.main.bounds.size.height / 4)
    }
    
    
    
}
