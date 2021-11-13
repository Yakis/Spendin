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
        
//        func itemTitle(for csc: UICloudSharingController) -> String? {
//            return list.entity.name
//        }
        
        
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
            //Pre-Create the CKShare record here, and assign to parent.share...
//            let moc = PersistenceManager.persistentContainer.newBackgroundContext()
//            let listToShare = moc.object(with: list) as! CDList
//            guard let rootRecord = PersistenceManager.persistentContainer.record(for: listToShare.objectID) else { return }
            
            let ckContainer = CKContainer(identifier: "iCloud.Spendin")
            let recordZoneID = CKRecordZone.ID(zoneName: "com.apple.coredata.cloudkit.zone", ownerName: CKCurrentUserDefaultName)
            let shareRecord = CKShare(recordZoneID: recordZoneID)
            shareRecord[CKShare.SystemFieldKey.title] = "Share Title" as CKRecordValue
            shareRecord.publicPermission = .none
            
            
            
            let sharingController =  UICloudSharingController { controller, preparationCompletionHandler in
                
                
                let modifyRecordsOperation = CKModifyRecordsOperation( recordsToSave: [shareRecord], recordIDsToDelete: nil)
                modifyRecordsOperation.configuration.timeoutIntervalForRequest = 10
                modifyRecordsOperation.configuration.timeoutIntervalForResource = 10
                
                modifyRecordsOperation.modifyRecordsResultBlock = { result in
                    switch result {
                    case .failure(let error):
                        print(error)
                        preparationCompletionHandler(nil, nil, error)
                    case .success: preparationCompletionHandler(shareRecord, ckContainer, nil)
                    }
                }
                ckContainer.privateCloudDatabase.add(modifyRecordsOperation)
            }
//            DispatchQueue.main.async {
                sharingController.delegate = self
                if let button = self.button {
                    sharingController.popoverPresentationController?.sourceView = button
                }
                UIApplication.shared.keyWindow?.rootViewController?.present(sharingController, animated: true, completion: {})
//            }
            
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
