//
//  TotalBottomView.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI

struct TotalBottomView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    @Binding var showModal: Bool
    @Binding var isUpdate: Bool
    var isReadOnly: Bool
    @State private var date = Date()
    
    var body: some View {
        HStack {
            if isReadOnly {
                Spacer()
            }
            Text("£ \(String(format: "%.2f", spendingVM.total)) left")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(isReadOnly ? [.trailing, .bottom] : [.leading, .bottom], 20)
                .frame(alignment: isReadOnly ? .trailing : .leading)
            if !isReadOnly {
            Spacer()
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 60, height: 60, alignment: .center)
                .foregroundColor(AdaptColors.theOrange)
                .shadow(radius: 2)
                .padding([.trailing, .bottom], 20)
                .onTapGesture {
                    isUpdate = false
                    showModal = true
                }
                .sheet(isPresented: $showModal) {
                    AddSpenderView(isUpdate: $isUpdate, date: $date)
                        .environmentObject(spendingVM)
                }
            }
        }
    }
    
    
}
