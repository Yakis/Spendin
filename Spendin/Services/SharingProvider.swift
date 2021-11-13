//
//  SharingProvider.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 12/11/2021.
//

import Foundation
import CoreData
import CloudKit
import UIKit

protocol RenderableUserIdentity {
    var nameComponents: PersonNameComponents? { get }
    var contactIdentifiers: [String] { get }
}

protocol RenderableShareParticipant {
    var renderableUserIdentity: RenderableUserIdentity { get }
    var role: CKShare.ParticipantRole { get }
    var permission: CKShare.ParticipantPermission { get }
    var acceptanceStatus: CKShare.ParticipantAcceptanceStatus { get }
}

protocol RenderableShare {
    var renderableParticipants: [RenderableShareParticipant] { get }
}

extension CKUserIdentity: RenderableUserIdentity {}

extension CKShare.Participant: RenderableShareParticipant {
    var renderableUserIdentity: RenderableUserIdentity {
        return userIdentity
    }
}

extension CKShare: RenderableShare {
    var renderableParticipants: [RenderableShareParticipant] {
        return participants
    }
}

protocol SharingProvider {
    func isShared(object: NSManagedObject) -> Bool
    func isShared(objectID: NSManagedObjectID) -> Bool
    func participants(for object: NSManagedObject) -> [RenderableShareParticipant]
    func shares(matching objectIDs: [NSManagedObjectID]) throws -> [NSManagedObjectID: RenderableShare]
    func canEdit(object: NSManagedObject) -> Bool
    func canDelete(object: NSManagedObject) -> Bool
}
