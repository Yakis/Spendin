//
//  SharingView.swift
//  Spendtrack
//
//  Created by Mugurel Moscaliuc on 10/07/2020.
//

import SwiftUI
import CoreData
import CloudKit

struct SharingView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    @State private var list: NSManagedObjectID?
    
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Sharing View")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
            }
            .onAppear {
                let item = spendingVM.listDataStore.getListForID(id: spendingVM.currentList.id)
                list = item.objectID
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let list = list {
                        UIKitCloudKitSharingButton(list: list)
                    }
                }
            }
        }
    }
}


