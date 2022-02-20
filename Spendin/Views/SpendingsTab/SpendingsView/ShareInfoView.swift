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
    
    @EnvironmentObject var spendingVM: SpendingVM
    var participants: Dictionary<NSManagedObject, [ShareParticipant]>
    
    var body: some View {
            VStack(alignment: .leading) {
                Text("Sharing:")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.bottom, 2)
                ForEach(participants[spendingVM.currentList!] ?? [], id: \.participantID) { participant in
                    if !participant.firstName.isEmpty {
                        Text(participant.firstName + " " + (participant.role == .owner ? "(owner)" : "(\(participant.permission.name))"))
                            .font(.caption)
                            .foregroundColor(AdaptColors.categoryIcon)
                            .opacity(0.8)
                    } else {
                        Text(participant.email + " - " + participant.acceptanceStatus.name)
                            .font(.caption)
                            .foregroundColor(AdaptColors.categoryIcon)
                            .opacity(0.8)
                    }
                }
            }.opacity(PersistenceManager.isShared(object: spendingVM.currentList!) ? 1 : 0)
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
