//
//  ShareController.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 11/11/2021.
//

import UIKit
import SwiftUI
import CloudKit
import CoreData

struct CloudKitSharingButton: UIViewRepresentable {
    typealias UIViewType = UIButton
    
    var list: NSManagedObjectID
    
    func makeUIView(context: UIViewRepresentableContext<CloudKitSharingButton>) -> UIButton {
        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .all
        configuration.image = UIImage(systemName: "person.crop.circle.badge.plus")
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(context.coordinator, action: #selector(context.coordinator.pressed(_:)), for: .touchUpInside)
        context.coordinator.button = button
        return button
    }
    
    func updateUIView(_ uiView: UIButton, context: UIViewRepresentableContext<CloudKitSharingButton>) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(list: list)
    }
    
    class Coordinator: NSObject, UICloudSharingControllerDelegate {
        
        
        var list: NSManagedObjectID
        var button: UIButton?
        
        init(list: NSManagedObjectID) {
            self.list = list
        }
        
               
        
        func cloudSharingControllerDidSaveShare(_ csc: UICloudSharingController) {
            print("cloudSharingControllerDidSaveShare: \(String(describing: csc.share))")
        }
        
        
        func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
            //Handle some errors here.
            print("cloudSharingController error: \(error)")
        }
        
        func itemTitle(for csc: UICloudSharingController) -> String? {
            let moc = PersistenceManager.persistentContainer.newBackgroundContext()
            let listToShare = moc.object(with: list)
            guard let title = listToShare.value(forKeyPath: "title") as? String else { return "No title for object" }
            print("Title: \(title)")
            return title
        }
        
        
        @objc func pressed(_ sender: UIButton) {
            let moc = PersistenceManager.persistentContainer.viewContext
            let listToShare = moc.object(with: list) as! CDList
            let container = PersistenceManager.persistentContainer
            let sharingController = UICloudSharingController {
                (controller, completion: @escaping (CKShare?, CKContainer?, Error?) -> Void) in
                container.share([listToShare], to: nil) { objectIDs, share, container, error in
                    if let actualShare = share {
                        listToShare.managedObjectContext?.performAndWait {
                            actualShare[CKShare.SystemFieldKey.title] = listToShare.title
                        }
                    }
                    completion(share, container, error)
                }
            }
            sharingController.delegate = self
            if let button = self.button {
                sharingController.popoverPresentationController?.sourceView = button
            }
            UIApplication.shared.keyWindow?.rootViewController?.present(sharingController, animated: true, completion: {})
            
        }
    }
}


extension UIApplication {
    
    var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
        // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
        // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
        // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
        // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
    
}
