//
//  SpendinApp.swift
//  Spendin
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI
import SwiftData

class AppDelegate: NSObject, UIApplicationDelegate {
    
    
    var window: UIWindow?
    
    static let sharedAppDelegate: AppDelegate = {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unexpected app delegate type, did it change? \(String(describing: UIApplication.shared.delegate))")
        }
        return delegate
    }()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        return true
    }
    
    
}


@main
struct SpendinApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    @StateObject var spendingVM: SpendingVM
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let modelContainer: ModelContainer
    
        
    init() {
        _spendingVM = StateObject(wrappedValue: SpendingVM())
        do {
            modelContainer = try ModelContainer(for: Item.self, ItemList.self, Suggestion.self)
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }
    
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(spendingVM)
        }
        .modelContainer(modelContainer)
    }
    
    
}

