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
    @State private var showQRCodeGenerator = false
    @State private var cancellables = Set<AnyCancellable>()
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                if spendingVM.lists.isEmpty {
                    VStack {
                        let image = Image(systemName: "plus.circle.fill")
                        Text("Nothing here, you can add a list from the \(image) button")
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .opacity(0.5)
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: [GridItem.init(.fixed(100), spacing: 10)],
                            spacing: 16
                        ) {
                            ForEach(0..<spendingVM.lists.count, id: \.self) { index in
                                if let list = spendingVM.lists[index] {
                                    NavigationLink {
                                        DetailedListView(list: list) {
                                            delete(list: list)
                                        }
                                    } label: {
                                        ListCell(list: list, geometry: geometry)
                                    }
                                }
                            }
                        }
                        .onChange(of: spendingVM.currentListItems) { newValue in
                            spendingVM.calculateSpendings()
                        }
                    }.padding(.top, 10)
                }
            }
            .navigationTitle("Lists")
            .sheet(isPresented: $showCreateNewListView) {
                
            } content: {
                if authService.isAuthenticated {
                    CreateNewListView()
                } else {
                    CloseableView {
                        AuthenticationView()
                    }
                }
            }
            .sheet(isPresented: $showQRCodeGenerator, content: {
                let userDetails = UserDetails(id: KeychainItem.currentUserIdentifier, isOwner: false, readOnly: true, email: KeychainItem.currentUserEmail)
                let image = generateQRCode(from: userDetails)
                    VStack(alignment: .center) {
                        HStack {
                            Text("Ask the owner of the list to scan the code bellow.")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.gray)
                                .multilineTextAlignment(.center)
                        }.padding()
                        Image(uiImage: image)
                            .resizable()
                            .interpolation(.none)
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .cornerRadius(16)
                            .padding()
                        Button {
                            showQRCodeGenerator = false
                            spendingVM.fetchLists()
                        } label: {
                            Text("Done")
                                .padding(5)
                        }
                        .padding()
                        .buttonStyle(.borderedProminent)

                    }
            })
            .toolbar {
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
    }
    
    
    private func delete(list: ItemList) {
        Task {
            try await spendingVM.delete(list: list)
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




struct ListCell: View {
    
    var list: ItemList
    var geometry: GeometryProxy
    
    var body: some View {
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
        .frame(height: 100)
        .frame(minWidth: geometry.size.width - 32)
        .background(AdaptColors.container)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding([.leading, .trailing], 16)
    }
    
    
}


