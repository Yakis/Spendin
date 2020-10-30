//
//  SpendyApp.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI
import Firebase

@main
struct SpendyApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    @StateObject var spendingVM = SpendingVM()
    @StateObject var siwaService = SiwAService()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if siwaService.isAuthenticated {
            ContentView()
                .environmentObject(spendingVM)
            } else {
                LoginView()
                    .environmentObject(siwaService)
            }
        }
    }
}

