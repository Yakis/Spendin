//
//  ItemStorage.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import UIKit
import CoreData
import CloudKit
import Combine

class PersistenceManager: NSObject {
    
    static var cancellables = Set<AnyCancellable>()
    
    
    static let persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Spendin")
        let description = container.persistentStoreDescriptions.first
        description?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description?.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        NotificationCenter.default
            .publisher(for: .NSPersistentStoreRemoteChange)
            .eraseToAnyPublisher()
            .sink { notification in
                print("NSPersistentStoreRemoteChange")
                NotificationCenter.default.post(name: .storeHasChanges, object: nil)
            }
            .store(in: &cancellables)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            try? container.viewContext.setQueryGenerationFrom(.current)
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    
    @objc func storeRemoteChange() {
        print("Remote Store changed!")
    }
    
    
    
}


extension NSManagedObjectContext {
    @discardableResult public func saveIfNeeded() throws -> Bool {
        guard hasChanges else { return false }
        try save()
        return true
    }
    
    
    public func executeAndMergeChanges(using batchDeleteRequest: NSBatchDeleteRequest) throws {
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        let result = try execute(batchDeleteRequest) as? NSBatchDeleteResult
        let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self])
    }
    
}
