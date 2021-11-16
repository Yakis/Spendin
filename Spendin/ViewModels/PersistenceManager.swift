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


// Mark - Sharing
extension PersistenceManager: SharingProvider {
    
    static func isShared(object: NSManagedObject) -> Bool {
        return isShared(objectID: object.objectID)
    }

    static func isShared(objectID: NSManagedObjectID) -> Bool {
        var isShared = false
        if let persistentStore = objectID.persistentStore {
            if persistentStore == PersistenceManager.sharedPersistentStore {
                isShared = true
            } else {
                let container = PersistenceManager.persistentContainer
                do {
                    let shares = try container.fetchShares(matching: [objectID])
                    if nil != shares.first {
                        isShared = true
                    }
                } catch let error {
                    print("Failed to fetch share for \(objectID): \(error)")
                }
            }
        }
        return isShared
    }
    
    static func participants(for object: NSManagedObject) -> [ShareParticipant] {
        var participants = [CKShare.Participant]()
        do {
            let container = PersistenceManager.persistentContainer
            let shares = try container.fetchShares(matching: [object.objectID])
            if let share = shares[object.objectID] {
                participants = share.participants
                return participants.map { ShareParticipant(from: $0) }
            }
        } catch let error {
            print("Failed to fetch share for \(object): \(error)")
        }
        return []
    }
    
    static func stopSharing(for object: NSManagedObject) {
        do {
            let container = PersistenceManager.persistentContainer
            let shares = try container.fetchShares(matching: [object.objectID])
            if let share = shares[object.objectID] {
                guard let participant = share.participants.filter({ participant in
                    let recordName = participant.userIdentity.userRecordID?.recordName
                    return !recordName!.contains("Owner")
                }).first else {return}
                print(participant)
                share.removeParticipant(participant)
            }
        } catch let error {
            print("Failed to fetch share for \(object): \(error)")
        }
    }
    
    
    static func shares(matching objectIDs: [NSManagedObjectID]) throws -> [NSManagedObjectID: RenderableShare] {
        return try PersistenceManager.persistentContainer.fetchShares(matching: objectIDs)
    }
    
    static func canEdit(object: NSManagedObject) -> Bool {
        return PersistenceManager.persistentContainer.canUpdateRecord(forManagedObjectWith: object.objectID)
    }
        
    static func canDelete(object: NSManagedObject) -> Bool {
        return PersistenceManager.persistentContainer.canDeleteRecord(forManagedObjectWith: object.objectID)
    }
}



struct ShareParticipant {
    var userID: String
    var participantID: String
    var firstName: String
    var lastName: String
    var email: String
    var permission: CKShare.ParticipantPermission
    var isCurrentUser: Bool
    var role: CKShare.ParticipantRole
    var acceptanceStatus: CKShare.ParticipantAcceptanceStatus
    
    
    init(from participant: CKShare.Participant) {
        let firstName = participant.renderableUserIdentity.nameComponents?.givenName ?? ""
        let lastName = participant.renderableUserIdentity.nameComponents?.familyName ?? ""
        let isCurrentUser = participant.value(forKeyPath: "isCurrentUser") as? Int ?? 0
        let participantID = participant.value(forKeyPath: "participantID") as? String ?? ""
        let email = participant.userIdentity.lookupInfo?.emailAddress ?? ""
        let userID = participant.userIdentity.userRecordID?.recordName ?? ""
        let role = participant.role
        let acceptanceStatus = participant.acceptanceStatus
        self.userID = userID
        self.participantID = participantID
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.permission = participant.permission
        self.isCurrentUser = isCurrentUser == 0 ? false : true
        self.role = role
        self.acceptanceStatus = acceptanceStatus
    }
    
    
}


extension CKShare.ParticipantPermission {
    
    var name: String {
        switch self {
        case .unknown: return "unknown"
        case .none: return "none"
        case .readOnly: return "read only"
        case .readWrite: return "read & write"
        default: return ""
        }
    }
    
}


extension CKShare.ParticipantRole {
    
    var name: String {
        switch self {
        case .unknown: return "unknown"
        case .owner: return "owner"
        case .privateUser: return "private user"
        case .publicUser: return "public user"
        default: return ""
        }
    }
    
}
