//
//  ShareInfoView.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 16/11/2021.
//

import SwiftUI
import CoreData
import CloudKit

struct ShareInfoView: View {
    
    var list: CDList
    
    @Binding var participants: Dictionary<NSManagedObject, [ShareParticipant]>
    
    var body: some View {
            VStack(alignment: .leading) {
                Text("Sharing:")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.bottom, 2)
                ForEach(participants[list] ?? [], id: \.participantID) { participant in
                    if !participant.firstName.isEmpty {
                        Text(participant.firstName + " " + (participant.role == .owner ? "(owner)" : "(\(participant.permission.name))"))
                            .font(.caption)
                            .foregroundColor(.gray)
                    } else {
                        Text(participant.email + " - " + participant.acceptanceStatus.name)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }.opacity(PersistenceManager.isShared(object: list) ? 1 : 0)
            .padding(.leading)
    }
}


extension CKShare.ParticipantAcceptanceStatus {
    
    var name: String {
        switch self {
        case.unknown: return "unknown"
        case .accepted: return "accepted"
        case .pending: return "pending"
        case .removed: return "removed"
        default: return ""
        }
    }
    
}
