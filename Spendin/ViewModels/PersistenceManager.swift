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
    
    static private var _privatePersistentStore: NSPersistentStore?
    static var privatePersistentStore: NSPersistentStore {
        return _privatePersistentStore!
    }
    
    static private var _sharedPersistentStore: NSPersistentStore?
    static var sharedPersistentStore: NSPersistentStore {
        return _sharedPersistentStore!
    }
    
    static let persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Spendin")
        
        let privateStoreDescription = container.persistentStoreDescriptions.first!
        let storesURL = privateStoreDescription.url!.deletingLastPathComponent()
        privateStoreDescription.url = storesURL.appendingPathComponent("private.sqlite")
        privateStoreDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        privateStoreDescription.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        //Add Shared Database
        let sharedStoreURL = storesURL.appendingPathComponent("shared.sqlite")
        guard let sharedStoreDescription = privateStoreDescription.copy() as? NSPersistentStoreDescription else {
            fatalError("Copying the private store description returned an unexpected value.")
        }
        sharedStoreDescription.url = sharedStoreURL
        
        let containerIdentifier = privateStoreDescription.cloudKitContainerOptions!.containerIdentifier
        let sharedStoreOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: containerIdentifier)
        sharedStoreOptions.databaseScope = .shared
        sharedStoreDescription.cloudKitContainerOptions = sharedStoreOptions
//
//        //Load the persistent stores
        container.persistentStoreDescriptions.append(sharedStoreDescription)
        
        container.loadPersistentStores(completionHandler: { (loadedStoreDescription, error) in
            if let loadError = error as NSError? {
                fatalError("###\(#function): Failed to load persistent stores:\(loadError)")
            } else if let cloudKitContainerOptions = loadedStoreDescription.cloudKitContainerOptions {
                if .private == cloudKitContainerOptions.databaseScope {
                    PersistenceManager._privatePersistentStore = container.persistentStoreCoordinator.persistentStore(for: loadedStoreDescription.url!)
                } else if .shared == cloudKitContainerOptions.databaseScope {
                    PersistenceManager._sharedPersistentStore = container.persistentStoreCoordinator.persistentStore(for: loadedStoreDescription.url!)
                }
            }
        })
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        do {
            try container.viewContext.setQueryGenerationFrom(.current)
        } catch {
            fatalError("###\(#function): Failed to pin viewContext to the current generation:\(error)")
        }
        return container
    }()
    
    
    
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
