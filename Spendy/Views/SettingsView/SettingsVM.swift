//
//  SettingsVM.swift
//  Spendy
//
//  Created by Mugurel on 26/07/2020.
//

import SwiftUI
import Combine

class SettingsVM: ObservableObject {
    
    
    @AppStorage("userToken") var userToken: String = ""
    
    func register(with auth: AuthObject, completion: @escaping (Data?, Error?) -> ()) {
        let dict = [
            "name": auth.name,
            "email": auth.email.lowercased(),
            "password": auth.password,
            "confirmPassword": auth.repeatPassword
        ]
        print(dict)
        let url = URL(string: "http://127.0.0.1:8080/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = try! JSONSerialization.data(withJSONObject: dict, options: [])
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
            } else {
                completion(data, nil)
            }
        }
        .resume()
    }
    
    
    
    
    func login(email: String, password: String, completion: @escaping (UserToken?, Error?) -> ()) {
        let loginString = String(format: "%@:%@", email.lowercased(), password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        print(base64LoginString)
        let url = URL(string: "http://127.0.0.1:8080/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
            } else {
                guard let data = data else {return}
                guard let token = try? JSONDecoder().decode(UserToken.self, from: data) else {return}
                self.userToken = token.value
                completion(token, nil)
            }
        }
        .resume()
    }
    
    
    
    
}
