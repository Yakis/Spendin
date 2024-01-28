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


extension EnvironmentValues {
    var spendingVM: SpendingVM {
        get { self[SpendingVMKey.self] }
        set { self[SpendingVMKey.self] = newValue }
    }
}


private struct SpendingVMKey: EnvironmentKey {
    static var defaultValue: SpendingVM = SpendingVM()
}



@main
struct SpendinApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let modelContainer: ModelContainer
    
        
    init() {
        do {
            let schema = Schema([ItemList.self, Item.self, Suggestion.self])
            let storeURL = URL.documentsDirectory.appending(path: "spendin.store")
            let config = ModelConfiguration.init(url: storeURL, cloudKitDatabase: .private("iCloud.Spendin"))
            modelContainer = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }
    
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
    
    
}

