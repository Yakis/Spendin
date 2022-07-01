//
//  SpendinApp.swift
//  Spendin
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI

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
    let sceneDelegate = MySceneDelegate()
    
    
    init() {
        _spendingVM = StateObject(wrappedValue: SpendingVM())
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(spendingVM)
                .withHostingWindow { window in
                    sceneDelegate.originalDelegate = window?.windowScene!.delegate
                    window?.windowScene!.delegate = sceneDelegate
                }
        }
    }
    
    
}


class MySceneDelegate : NSObject, UIWindowSceneDelegate {
    var originalDelegate: UISceneDelegate?
    
    
    // forward all other UIWindowSceneDelegate/UISceneDelegate callbacks to original, like
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        originalDelegate?.scene!(scene, willConnectTo: session, options: connectionOptions)
    }
}


extension View {
    func withHostingWindow(_ callback: @escaping (UIWindow?) -> Void) -> some View {
        self.background(HostingWindowFinder(callback: callback))
    }
}

struct HostingWindowFinder: UIViewRepresentable {
    var callback: (UIWindow?) -> ()
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async { [weak view] in
            self.callback(view?.window)
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
