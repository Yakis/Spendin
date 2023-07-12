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
    @State private var date = Date()
    var list: ItemList
    var item: Item
    
    var body: some View {
        HStack {
            Text("\(spendingVM.currency) \(String(format: "%.2f", spendingVM.total)) left")
                .font(.title2)
                .fontWeight(.semibold)
                .padding([.leading, .bottom], 20)
                .frame(alignment: .leading)
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
                    AddSpenderView(isUpdate: $isUpdate, date: $date, list: list, item: isUpdate ? item : Item())
                        .environmentObject(spendingVM)
                }
        }
    }
    
    
}
