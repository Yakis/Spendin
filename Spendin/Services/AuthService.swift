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
import Contacts

@MainActor
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
        checkIfIsAuthenticated()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    
    // Apple
    func login(authorization: ASAuthorization, completion: @escaping () -> ()) {
        isLoading = true
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            Task {
                let user = try await createUser(token: idTokenString, name: appleIDCredential.fullName?.formatted())
                let userIdentifier = user.id
                self.userEmail = user.email
                self.saveEmailInKeychain(userEmail)
                self.saveUserInKeychain(userIdentifier)
                self.saveProviderInKeychain("apple.com")
                self.isLoading = false
                self.checkIfIsAuthenticated()
                NotificationCenter.default.post(name: .authDidChange, object: nil, userInfo: ["isAuthenticated": isAuthenticated])
                completion()
            }
        }
    }
    
    
    func createUser(token: String, name: String?) async throws -> User {
        var request = URLRequest(url: .createUser())
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let encodedName = try JSONEncoder().encode(["name": name])
        let (data, response) = try await session().upload(for: request, from: encodedName)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error while creating user: \((response as? HTTPURLResponse).debugDescription)")
        }
        let user = try JSONDecoder().decode(User.self, from: data)
        print(user)
        return user
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
        NotificationCenter.default.post(name: .authDidChange, object: nil, userInfo: ["isAuthenticated": isAuthenticated])
        completion(NSLocalizedString("Logged out.", comment: ""))
    }
    
    
}
