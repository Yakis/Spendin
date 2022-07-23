//
//  ShareListView.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 12/07/2022.
//

import SwiftUI

struct ShareListView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    var list: ItemList
    @Binding var showSharingList: Bool
    @Binding var showShareSheet: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "person.crop.circle.badge.plus")
                .symbolRenderingMode(.hierarchical)
                .font(.system(size: 60))
                .foregroundColor(AdaptColors.theOrange)
                .opacity(0.7)
            Spacer()
            Text("Sharing **\(list.name)**")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding([.leading, .trailing], 30)
            Spacer()
            Toggle("Read only", isOn: $spendingVM.readOnly)
                .tint(AdaptColors.theOrange)
                .padding([.leading, .trailing], 50)
            Spacer()
            Button {
                Task {
                    try! await spendingVM.shorten()
                    showShareSheet = true
                    showSharingList = false
//                    print("====================================")
//                    print(spendingVM.shortenedURL)
//                    print("====================================")
                }
            } label: {
                Text("Share")
                    .padding(5)
            }
            .buttonStyle(.borderedProminent)
            .tint(AdaptColors.theOrange)
            .padding(8)
            Spacer()
        }
        .frame(maxHeight: .infinity)
    }
    
    
    
}
