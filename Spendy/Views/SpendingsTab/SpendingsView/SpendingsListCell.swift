//
//  SpendingsListCell.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI

struct SpendingsListCell: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    var item: Item
    @Binding var isUpdate: Bool
    @Binding var showModal: Bool
    
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Label("", systemImage: item.category).font(.largeTitle)
                    .foregroundColor(item.type == "expense" ? .red : .green)
                VStack(alignment: .leading) {
                    Text("\(item.name)")
                        .font(.custom("HelveticaNeue-Bold", size: 20))
                        .padding(.bottom, 10)
                    Text((item.date.shortString()))
                        .font(.custom("HelveticaNeue-Light", size: 14))
                }
                Spacer()
                VStack {
                Text(amountString(item: item))
                    .font(.custom("HelveticaNeue-Bold", size: 20))
                    .padding(.bottom, 10)
                    Text("£" + " " + String(format: "%.2f", item.amountLeft))
                        .font(.custom("HelveticaNeue-Light", size: 14))
                }
                Spacer().frame(width: 20, height: 80, alignment: .leading)
            }
            .frame(width: UIScreen.main.bounds.width - 32, height: 80, alignment: .leading)
            .shadow(radius: 2)
        }
        .onTapGesture {
            isUpdate = true
            showModal = true
            spendingVM.itemToUpdate = item
        }
    }
    
    
    private func amountString(item: Item) -> String {
        switch item.type {
        case "expense": return "- £ \(String(format: "%.2f", item.amount))"
        default: return "+ £ \(String(format: "%.2f", item.amount))"
        }
    }
    
    

    
    
}
