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
    
    init() {
        _spendingVM = StateObject(wrappedValue: SpendingVM())
    }
    
    let container: ModelContainer = {
        let schema = Schema([
            ItemList.self,
            Item.self,
            Suggestion.self
        ])
        let config = ModelConfiguration()
        return try! ModelContainer(for: schema, configurations: [config])
    }()
    
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(spendingVM)
        }
        .modelContainer(container)
    }
    
    
}

