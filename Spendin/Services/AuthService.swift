//
//  AuthService.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 03/07/2022.
//

import Foundation
import UIKit
import Combine
import CryptoKit
import AuthenticationServices


class AuthService: ObservableObject {
    
    
    @Published var isLoading: Bool = false
    @Published var isAuthenticated: Bool = false
    @Published var userEmail: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    
    private func session() -> URLSession {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        return URLSession(configuration: config)
    }
    
    
    init() {
//        logout { message in
//            print(message)
//        }
        checkIfIsAuthenticated()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    
    // Apple
    func login(authorization: ASAuthorization, completion: @escaping () -> ()) {
        isLoading = true
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            self.userEmail = appleIDCredential.email ?? "private email"
            self.saveEmailInKeychain(userEmail)
            self.saveUserInKeychain(userIdentifier)
            self.saveProviderInKeychain("apple.com")
            self.isLoading = false
            self.checkIfIsAuthenticated()
            completion()
        }
    }
    
    
    func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "com.yakis.Spendin", account: "userIdentifier").saveItem(userIdentifier)
            checkIfIsAuthenticated()
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
    
    
    func saveEmailInKeychain(_ email: String) {
        do {
            try KeychainItem(service: "com.yakis.Spendin", account: "email").saveItem(email)
            checkIfIsAuthenticated()
        } catch {
            print("Unable to save email to keychain.")
        }
    }
    
    
    func saveProviderInKeychain(_ provider: String) {
        do {
            try KeychainItem(service: "com.yakis.Spendin", account: "authProvider").saveItem(provider)
            checkIfIsAuthenticated()
        } catch {
            print("Unable to save auth provider to keychain.")
        }
    }
    
    
    
    func checkIfIsAuthenticated() {
        if KeychainItem.currentUserIdentifier.isEmpty {
            isAuthenticated = false
        } else {
            isAuthenticated = true
            userEmail = KeychainItem.currentUserEmail
        }
    }
    
    
    
    func logout(completion: @escaping(String) -> ()) {
        KeychainItem.deleteUserIdentifierFromKeychain()
        KeychainItem.deleteUserEmailFromKeychain()
        KeychainItem.deleteAuthProviderFromKeychain()
        checkIfIsAuthenticated()
        completion(NSLocalizedString("Logged out.", comment: ""))
    }
}
