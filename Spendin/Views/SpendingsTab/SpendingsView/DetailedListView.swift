//
//  SpendingsView.swift
//  Spendtrack
//
//  Created by Mugurel Moscaliuc on 10/07/2020.
//

import SwiftUI
import Combine
import SwiftData
import CloudKit
import UIKit


struct DetailedListView: View {
    
    @Environment(\.spendingVM) private var spendingVM
    @State var showModal: Bool = false
    @State var isUpdate: Bool = false
    @State private var isLoading: Bool = true
    @State private var cancellable: AnyCancellable?
    @State private var showInvalidQRAlert = false
    @State private var showQRCodeScanner = false
    @State private var showSharingList = false
    @State private var showEditSharingView = false
    @State private var showShareSheet = false
        
    var list: ItemList
    
    var body: some View {
            ZStack {
                VStack(alignment: .leading) {
                    ItemsView(showModal: $showModal, isUpdate: $isUpdate, list: list)
                    TotalBottomView(showModal: $showModal, isUpdate: $isUpdate, list: list)
                }
                .background(AdaptColors.container)
                ProgressView("Syncing data...").opacity(spendingVM.isLoading ? 1 : 0)
            }
            .navigationTitle(list.name)
            .navigationBarTitleDisplayMode(.large)
        // Later if we share with iCloud
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Menu {
//                        Button {
//                            showSharingList = true
//                        } label: {
//                            Label("Share list", systemImage: "square.and.arrow.up")
//                                .foregroundColor(AdaptColors.theOrange)
//                        }
//                        Button {
//                            showEditSharingView = true
//                        } label: {
//                            Label("Manage permissions", systemImage: "person.crop.circle.badge.checkmark")
//                                .foregroundColor(AdaptColors.theOrange)
//                        }
//                    } label: {
//                        Image(systemName: "person.crop.circle.fill")
//                            .foregroundColor(AdaptColors.theOrange)
//                    }
//                }
//            }
    }
    
    
}
