//
//  ListsView.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 14/11/2021.
//

import SwiftUI
import Combine
import UIKit
import CoreImage.CIFilterBuiltins

struct SpendingsView: View {
    
    var body: some View {
        PageView()
    }
    
}


struct PageView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    @EnvironmentObject var authService: AuthService
    @State private var currentIndex: Int?
    @State private var size: CGSize = .zero
    @State private var showCreateNewListView = false
    @State private var showDeleteListAlert = false
    @State private var showDeleteRestrictionAlert = false
    @State private var showQRCodeGenerator = false
    @State private var cancellables = Set<AnyCancellable>()
    @State private var listToDelete: ItemList?
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    private var currentUser: UserDetails? {
        if let list = listToDelete {
            return list.users.filter { user in
                user.email == KeychainItem.currentUserEmail
            }.first!
        }
        return nil
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { geometry in
                    if spendingVM.lists.isEmpty && !spendingVM.isLoading {
                        VStack {
                            let image = Image(systemName: "plus.circle.fill")
                            Text("Nothing here, you can add a list from the \(image) button")
                                .font(.title)
                                .multilineTextAlignment(.center)
                                .opacity(0.5)
                        }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        SummaryListView(listToDelete: $listToDelete, currentUser: currentUser, showDeleteListAlert: $showDeleteListAlert, showDeleteRestrictionAlert: $showDeleteRestrictionAlert)
                            .onChange(of: spendingVM.currentListItems) { newValue in
                                spendingVM.calculateSpendings()
                            }
                            .alert("Warning", isPresented: $showDeleteListAlert) {
                                Button("Cancel", role: .cancel, action: {
                                    showDeleteListAlert = false
                                    listToDelete = nil
                                })
                                Button("Delete", role: .destructive, action: { delete(list: listToDelete) })
                            } message: {
                                Text("Are you sure you want to delete this list?")
                            }
                    }
                }
                .navigationTitle("Lists")
                .sheet(isPresented: $showCreateNewListView) {
                    
                } content: {
                    if authService.isAuthenticated {
                        CloseableView {
                            CreateNewListView()
                        }
                    } else {
                        CloseableView {
                            AuthenticationView()
                        }
                    }
                }
                .sheet(isPresented: $showQRCodeGenerator, content: {
                    let userDetails = UserDetails(id: KeychainItem.currentUserIdentifier, isOwner: false, readOnly: true, email: KeychainItem.currentUserEmail)
                    let image = generateQRCode(from: userDetails)
                    CloseableView {
                        QRGeneratorView(image: image)
                            .frame(maxHeight: .infinity)
                    }
                })
                .alert("Warning", isPresented: $showDeleteRestrictionAlert) {
                    Button("Dismiss", role: .cancel, action: {
                        showDeleteRestrictionAlert = false
                        listToDelete = nil
                    })
                } message: {
                    Text("You don't have the permission to delete this list.")
                }
                .toolbar {
                    MainViewToolbar(showCreateNewListView: $showCreateNewListView, showQRCodeGenerator: $showQRCodeGenerator)
                }
                ProgressView("Loading...").opacity((spendingVM.isLoading) ? 1 : 0)
            }
            .refreshable(action: {
                spendingVM.getCurrentUser()
            })
        }
    }
    
    
    private func delete(list: ItemList?) {
        if let list = list {
            Task {
                try await spendingVM.delete(list: list)
                listToDelete = nil
            }
        }
    }
    
    
    private func generateQRCode(from userDetails: UserDetails) -> UIImage {
        filter.message = try! JSONEncoder().encode(userDetails)
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    
}



struct MainViewToolbar: ToolbarContent {
    
    @Binding var showCreateNewListView: Bool
    @Binding var showQRCodeGenerator: Bool
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
                Button {
                    showCreateNewListView.toggle()
                } label: {
                    Label("New list", systemImage: "plus.circle.fill")
                }
                Button {
                    showQRCodeGenerator = true
                } label: {
                    Label("Get an invitation", systemImage: "qrcode")
                }
                Button {
                    
                } label: {
                    Label("Import", systemImage: "square.and.arrow.down")
                }
            } label: {
                Image(systemName: "plus.circle.fill")
            }
        }
    }
}



struct SummaryListView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    @Binding var listToDelete: ItemList?
    var currentUser: UserDetails?
    @Binding var showDeleteListAlert: Bool
    @Binding var showDeleteRestrictionAlert: Bool
    
    var body: some View {
        List {
            ForEach(0..<spendingVM.lists.count, id: \.self) { index in
                if let list = spendingVM.lists[index] {
                    NavigationLink {
                        DetailedListView(list: list)
                    } label: {
                        HStack {
                            Text(list.name)
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(10)
                            Spacer()
                            Text("\(list.itemsCount) items")
                                .font(.caption)
                                .fontWeight(.light)
                                .padding(10)
                        }
                    }
                }
            }
            .onDelete { index in
                listToDelete = spendingVM.lists[index.first!]
                if let user = currentUser, !user.readOnly {
                    showDeleteListAlert = true
                } else {
                    showDeleteRestrictionAlert = true
                }
            }
        }
    }
    
}
