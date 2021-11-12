//
//  SpendinApp.swift
//  Spendin
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI
import CloudKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    
    var window: UIWindow?
    var locationManager: CLLocationManager = CLLocationManager()
    var locationAuthorized: Bool {
#if targetEnvironment(macCatalyst)
        return locationManager.authorizationStatus == .authorizedAlways
#else
        return locationManager.authorizationStatus == .authorizedWhenInUse
#endif //#if targetEnvironment(macCatalyst)
    }
    
    
    static let sharedAppDelegate: AppDelegate = {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unexpected app delegate type, did it change? \(String(describing: UIApplication.shared.delegate))")
        }
        return delegate
    }()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    
    func application(_ application: UIApplication, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata) {
        let sharedStore = PersistenceManager.sharedPersistentStore
        let container = PersistenceManager.persistentContainer
        container.acceptShareInvitations(from: [cloudKitShareMetadata], into: sharedStore, completion: nil)
    }
    
}


@main
struct SpendinApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    @StateObject var spendingVM = SpendingVM()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(spendingVM)
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

