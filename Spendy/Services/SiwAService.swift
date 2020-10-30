//
//  SiwAService.swift
//  Spendy
//
//  Created by Mugurel on 30/10/2020.
//

import UIKit
import Firebase
import Combine
import CryptoKit
import AuthenticationServices


class SiwAService: ObservableObject {
    
    
    @Published var currentNonce: String?
    @Published var isLoading: Bool = false
    @Published var isAuthenticated: Bool = false
    
    
    
    init() {
        currentNonce = randomNonceString()
        checkIfIsAuthenticated()
    }
    
    
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    
    
    
    func login(authorization: ASAuthorization, completion: @escaping (AuthDataResult) -> ()) {
        isLoading = true
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                isLoading = false
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                isLoading = false
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                isLoading = false
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
                if (error != nil) {
                    self?.isLoading = false
                    print(error?.localizedDescription ?? "SignIn unknown error")
                    return
                }
                // User is signed in to Firebase with Apple.
                guard let userIdentifier = authResult?.user.uid else {return}
                self?.saveUserInKeychain(userIdentifier)
                completion(authResult!)
                self?.isLoading = false
                self?.checkIfIsAuthenticated()
            }
        }
    }
    
    
    
    private func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "com.yakis.Spendy", account: "userIdentifier").saveItem(userIdentifier)
                checkIfIsAuthenticated()
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
    
    
    
    
    func logout(completion: @escaping(String) -> ()) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            KeychainItem.deleteUserIdentifierFromKeychain()
            checkIfIsAuthenticated()
        } catch let signOutError as NSError {
            let message = "Error signing out: \(signOutError)"
            completion(message)
        }
    }
    
    
    
    func checkIfIsAuthenticated() {
        if KeychainItem.currentUserIdentifier.isEmpty {
            isAuthenticated = false
        } else {
            isAuthenticated = true
        }
    }
    
    
    
    
    func testAuthAPI() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
          if let error = error {
            print("Firebase error retrieving user token: \(error)")
            return;
          }
          // Send token to your backend via HTTPS
          print("ID Token for backend: \(idToken!)")
        }
    }
    
    
    
}
