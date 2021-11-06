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
            HStack(spacing: 16) {
                Label("", systemImage: item.category)
                    .font(.title)
                    .foregroundColor(item.type == .expense ? .red : .green)
                VStack(alignment: .leading) {
                    Text("\(item.name)")
                        .font(.title2)
                        .fontWeight(.thin)
                        .padding(.bottom, 5)
                    Text((item.date.shortString()))
                        .font(.caption2)
                        .fontWeight(.thin)
                }
                Spacer()
                Text(amountString(item: item))
                    .font(.title3)
                    .fontWeight(.thin)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60, alignment: .leading)
            .shadow(radius: 1)
        }
        .onTapGesture {
            isUpdate = true
            showModal = true
            spendingVM.itemToUpdate = item
            print("ItemToUpdate: \(spendingVM.itemToUpdate)")
        }
    }
    
    
    private func amountString(item: Item) -> String {
        switch item.type {
        case .expense: return "- £ \(item.amount)"
        default: return "+ £ \(item.amount)"
        }
    }
    
    

    
    
}
