//
//  SpendingsListCell.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI

var shouldCalculateDate: Bool = true


struct DetailedListItemCell: View {
    
    @AppStorage("currency") var currency = "$"
    @Environment(\.spendingVM) private var spendingVM
    var item: Item
    @Binding var isUpdate: Bool
    @Binding var showModal: Bool
    @State private var showUpdateRestrictionAlert = false
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: item.category)
                    .font(.title2)
                    .frame(width: 30)
                    .foregroundColor(AdaptColors.categoryIcon)
                    .padding(.trailing, 5)
                    .offset(x: item.due.isToday() ? 16 : 0)
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.title2)
                        .fontWeight(.thin)
                        .padding(.bottom, 1)
                    Text((item.due.shortString()))
                        .font(.caption2)
                        .fontWeight(.thin)
                }.offset(x: item.due.isToday() ? 16 : 0)
                Spacer()
                VStack(alignment: .trailing) {
                    HStack {
                        Image(systemName: item.itemType == ItemType.expense ? "arrowtriangle.down.fill" : "arrowtriangle.up.fill")
                            .font(.caption2)
                            .foregroundColor(item.itemType == ItemType.expense ? .red : .green)
                        Text(amountString(item: item))
                            .font(.title3)
                            .fontWeight(.thin)
                    }
                        Text(spendingVM.amountList[item.amount + item.name] ?? "ERROR")
                            .font(.caption2)
                            .fontWeight(.thin)
                }
            }
            .frame(maxWidth: .infinity)
            .shadow(radius: 1)
        }
        .frame(height: 60, alignment: .leading)
        .cornerRadius(10)
        .onTapGesture {
            isUpdate = true
            showModal = true
            spendingVM.itemToSave = item
        }
        .overlay {
            HStack {
                Text("Due")
                    .font(.caption2)
                    .frame(height: item.due.isToday() ? 16 : 0)
                    .frame(width: item.due.isToday() ? 65 : 0)
                    .padding(3)
                    .background(AdaptColors.theOrange)
                    .opacity(item.due.isToday() ? 1 : 0)
                    .rotationEffect(Angle(degrees: -90))
                    .position(x: -9, y: 60 / 2)
            }
        }
    }
    
    
    private func amountString(item: Item) -> String {
        switch item.itemType {
        case ItemType.expense: return "\(currency) \(item.amount)"
        default: return "\(currency) \(item.amount)"
        }
    }
    
    
}

