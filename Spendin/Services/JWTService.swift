//
//  JWTService.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 03/07/2022.
//

import Foundation
import SwiftJWT

enum JWTService {
    
    static func getJWTFromUID() -> String {
        if !KeychainItem.currentUserIdentifier.isEmpty {
            let userIdentifier = KeychainItem.currentUserIdentifier
            let userEmail = KeychainItem.currentUserEmail
            let authProvider = KeychainItem.currentAuthProvider
            do {
                let header = Header(kid: "spdn2022")
                let claims = SiwaClaims(sub: userIdentifier, iss: authProvider, aud: "com.yakis.Spendin", iat: Date(timeIntervalSinceNow: -10), exp: Date(timeIntervalSinceNow: 3600), email: userEmail)
                let myJWT = JWT(header: header, claims: claims)
                if let path = Bundle.main.url(forResource: "private_key", withExtension: "txt") {
                    let stringu = try? String(contentsOf: path)
                    let privateKey = stringu!.data(using: String.Encoding.utf8)
                    let jwtSigner = JWTSigner.es256(privateKey: privateKey!)
                    let jwtEncoder = JWTEncoder(jwtSigner: jwtSigner)
                    let jwtString = try jwtEncoder.encodeToString(myJWT)
                    return jwtString
                }
            } catch {
                print("Error creating jwt: \(error)")
            }
        }
        return ""
    }
    
    
    
}


struct SiwaClaims: Claims {
    let sub: String
    let iss: String
    let aud: String
    let iat: Date
    let exp: Date
    let email: String
}

struct UserInfo: Claims {
    var iss: String
    var aud: String
    var exp: Int
    var iat: String
    var sub: String
    var email: String
    var email_verified: String
}

