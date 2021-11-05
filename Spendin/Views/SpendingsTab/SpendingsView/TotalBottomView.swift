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
    
    var body: some View {
        HStack {
            Text("£ \(String(format: "%.2f", spendingVM.total)) left")
                .font(.custom("HelveticaNeue-Bold", size: 24))
                .padding([.leading, .bottom], 20)
            Spacer()
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 60, height: 60, alignment: .center)
                .foregroundColor(AdaptColors.theOrange)
                .shadow(radius: 2)
                .transition(.scale)
                .padding([.trailing, .bottom], 20)
                .onTapGesture {
                    showModal.toggle()
                }
                .sheet(isPresented: $showModal) {
                    AddSpenderView(isUpdate: $isUpdate)
                        .environmentObject(spendingVM)
                }
        }
    }
    
}
