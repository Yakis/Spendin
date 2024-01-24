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
import CoreImage.CIFilterBuiltins

//enum ItemType: String, CaseIterable, Codable {
//    case expense, income
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        let rawString = try container.decode(String.self)
//        
//        if let type = ItemType(rawValue: rawString.lowercased()) {
//            self = type
//        } else {
//            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot initialize UserType from invalid String value \(rawString)")
//        }
//    }
//    
//}



struct DetailedListView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    @State var showModal: Bool = false
    @State var isUpdate: Bool = false
    @State private var isLoading: Bool = true
    @State private var cancellable: AnyCancellable?
    @State private var showInvalidQRAlert = false
    @State private var showQRCodeScanner = false
    @State private var showSharingList = false
    @State private var showEditSharingView = false
    @State private var showShareSheet = false
    @State private var item: Item = Item()
    
    @Query private var lists: [ItemList]
    
    var list: ItemList
    
    var body: some View {
            ZStack {
                VStack(alignment: .leading) {
                    ItemsView(showModal: $showModal, isUpdate: $isUpdate, selectedItem: $item)
                    TotalBottomView(showModal: $showModal, isUpdate: $isUpdate, list: list, item: item)
                        .environmentObject(spendingVM)
                }
                .background(AdaptColors.container)
                .onAppear {
                    spendingVM.currentList = list
                }
                ProgressView("Syncing data...").opacity(spendingVM.isLoading ? 1 : 0)
            }
            .navigationTitle(list.name)
            .navigationBarTitleDisplayMode(.large)
        // Later if we sync with iCloud
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
