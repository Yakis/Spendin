//
//  SpendinApp.swift
//  Spendin
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI

@main
struct SpendinApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    @StateObject var spendingVM = SpendingVM()
    let persistenceManager: PersistenceManager
    @StateObject var dataStorage: ItemStorage
    
    
    init() {
        let manager = PersistenceManager()
        self.persistenceManager = manager
        
        
        let managedObjectContext = PersistenceManager.persistentContainer.viewContext
        let storage = ItemStorage(managedObjectContext: managedObjectContext)
        self._dataStorage = StateObject(wrappedValue: storage)
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView().background(AdaptColors.container).edgesIgnoringSafeArea(.bottom)
                .environmentObject(spendingVM)
                .environment(\.managedObjectContext, PersistenceManager.persistentContainer.viewContext)
        }
        .onChange(of: scenePhase) { phase in
            do {
            try PersistenceManager.persistentContainer.viewContext.save()
            } catch {
                print("Error saving data")
            }
        }
    }
}

