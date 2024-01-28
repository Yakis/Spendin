//
//  TotalBottomView.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI

struct TotalBottomView: View {
    
    @AppStorage("currency") var currency = "$"
    @Environment(\.spendingVM) private var spendingVM
    @Binding var showModal: Bool
    @Binding var isUpdate: Bool
    var list: ItemList
    
    var body: some View {
        HStack {
            Text("\(currency) \(String(format: "%.2f", spendingVM.total)) left")
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
                    spendingVM.itemToSave = Item()
                }
                .sheet(isPresented: $showModal) {
                    AddSpenderView(isUpdate: $isUpdate, list: list)
                }
        }
        .onAppear {
            spendingVM.calculateSpendings(list: list)
        }
    }
    
    
}
