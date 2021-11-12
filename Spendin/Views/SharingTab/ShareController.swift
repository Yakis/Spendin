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

struct UIKitCloudKitSharingButton: UIViewRepresentable {
    typealias UIViewType = UIButton

    var list: NSManagedObjectID
    
    func makeUIView(context: UIViewRepresentableContext<UIKitCloudKitSharingButton>) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: "person.crop.circle.badge.plus"), for: .normal)
        button.addTarget(context.coordinator, action: #selector(context.coordinator.pressed(_:)), for: .touchUpInside)
        context.coordinator.button = button
        return button
    }

    func updateUIView(_ uiView: UIButton, context: UIViewRepresentableContext<UIKitCloudKitSharingButton>) {
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
        
        
        func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
            //Handle some errors here.
            print("cloudSharingController error: \(error)")
        }

        func itemTitle(for csc: UICloudSharingController) -> String? {
            let moc = PersistenceManager.persistentContainer.newBackgroundContext()
            let listToShare = moc.object(with: list)
            guard let name = listToShare.value(forKeyPath: "name") as? String else { return "No name for object" }
            print("Name: \(name)")
            return name
        }


        @objc func pressed(_ sender: UIButton) {
            //Pre-Create the CKShare record here, and assign to parent.share...
            let moc = PersistenceManager.persistentContainer.newBackgroundContext()
            let listToShare = moc.object(with: list)
            let sharingController = UICloudSharingController { (controller, completion: @escaping (CKShare?, CKContainer?, Error?) -> Void) in
                PersistenceManager.persistentContainer.share([listToShare], to: nil) { objectIDs, share, container, error in
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
