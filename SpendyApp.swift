//
//  SpendyApp.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI

@main
struct SpendyApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    let persistenceManager: PersistenceManager
    @StateObject var itemStorage: ItemStorage
    @StateObject var spendingVM = SpendingVM()
    
    
    init() {
        let manager = PersistenceManager()
        self.persistenceManager = manager

        let managedObjectContext = manager.persistentContainer.viewContext
        let storage = ItemStorage(managedObjectContext: managedObjectContext)
        self._itemStorage = StateObject(wrappedValue: storage)
      }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(spendingVM)
                .environmentObject(itemStorage)
                .environment(\.managedObjectContext, persistenceManager.persistentContainer.viewContext)
        }
        .onChange(of: scenePhase) { phase in
                    switch phase {
                    case .background:
                        do {
                        try persistenceManager.persistentContainer.viewContext.save()
                        } catch {
                            print(error)
                        }
                    case .active:
                        do {
                        try persistenceManager.persistentContainer.viewContext.save()
                        } catch {
                            print(error)
                        }
                    case .inactive:
                        do {
                        try persistenceManager.persistentContainer.viewContext.save()
                        } catch {
                            print(error)
                        }
                    default: break
                    }
                }
    }
}

