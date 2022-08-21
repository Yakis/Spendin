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
    @StateObject var authService = AuthService()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showListInviteConfirmation = false
    @State private var readOnly: Bool = true
    
    init() {
        _spendingVM = StateObject(wrappedValue: SpendingVM())
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(spendingVM)
                .environmentObject(authService)
                .sheet(isPresented: $showListInviteConfirmation, content: {
                    AcceptSharingView(readOnly: readOnly).environmentObject(spendingVM)
                })
                .onOpenURL { url in
                    print("URL: \(url.absoluteString)")
                    Task {
                        let longURLString = try await spendingVM.fetchShortened(id: url.lastPathComponent)
                        guard let longURL = URL(string: longURLString) else {
                            print("Url expired!")
                            return
                        }
                        if let scheme = longURL.scheme, scheme.localizedCaseInsensitiveCompare("com.spendin") == .orderedSame {
                            print("Scheme: \(scheme)")
                            var parameters: [String: String] = [:]
                            URLComponents(url: longURL, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
                                parameters[$0.name] = $0.value
                            }
                            print("PARAMS============== \(parameters)")
                            guard let id = parameters["list"], !id.isEmpty else {return}
                            print("ID============== \(id)")
                            guard let readOnly = parameters["readonly"]?.boolean else {return}
                            print("READ ONLY============== \(readOnly)")
                            self.readOnly = readOnly
                            spendingVM.getListFor(id: id)
                            showListInviteConfirmation = true
                        }
                    }
                }
        }
    }
    
    
}


struct AcceptSharingView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    @Environment(\.presentationMode) var presentationMode
    var readOnly: Bool
    
    var body: some View {
        VStack {
            if let list = spendingVM.sharedList, let owner = list.users.first(where: { $0.isOwner == true }) {
                Text("**\(owner.email)** \nwants to share \n**\(list.name)** \nwith you.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                            .padding(5)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AdaptColors.theOrange)
                    .opacity(0.7)
                    .padding(.trailing, 50)
                    Button {
                        let userDetails = UserDetails(id: KeychainItem.currentUserIdentifier, isOwner: false, readOnly: readOnly, email: KeychainItem.currentUserEmail)
                        spendingVM.acceptInvitation(for: userDetails, to: list)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Accept")
                            .padding(5)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AdaptColors.theOrange)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 50)
            }
        }.frame(maxHeight: .infinity)
    }
}
