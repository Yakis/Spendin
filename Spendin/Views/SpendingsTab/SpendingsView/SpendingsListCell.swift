//
//  SpendingsListCell.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI

var shouldCalculateDate: Bool = true


struct SpendingsListCell: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    var item: Item
    @Binding var isUpdate: Bool
    @Binding var showModal: Bool
    
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: item.category)
                    .font(.title2)
                    .frame(width: 30)
                    .foregroundColor(AdaptColors.categoryIcon)
                    .padding(.trailing, 5)
                VStack(alignment: .leading) {
                    Text("\(item.name)")
                        .font(.title2)
                        .fontWeight(.thin)
                        .padding(.bottom, 1)
                    Text((item.date.shortString()))
                        .font(.caption2)
                        .fontWeight(.thin)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    HStack {
                        Image(systemName: item.type == .expense ? "arrowtriangle.down.fill" : "arrowtriangle.up.fill")
                            .font(.caption2)
                            .foregroundColor(item.type == .expense ? .red : .green)
                        Text(amountString(item: item))
                            .font(.title3)
                            .fontWeight(.thin)
                    }
                    Text(item.amountLeft)
                        .font(.caption2)
                        .fontWeight(.thin)
                }
            }
            .frame(maxWidth: .infinity)
            .shadow(radius: 1)
            .padding()
        }
        .frame(height: 60, alignment: .leading)
        .background(getInterval(from: item.date, to: Date())  == .zero ? AdaptColors.theOrange.opacity(0.3) : AdaptColors.cellBackground)
        .cornerRadius(10)
        .onTapGesture {
            isUpdate = true
            showModal = true
            spendingVM.itemToUpdate = item
        }
    }
    
    
    private func amountString(item: Item) -> String {
        switch item.type {
        case .expense: return "£ \(item.amount)"
        default: return "£ \(item.amount)"
        }
    }
    
    
    
    func getInterval(from startDate: Date, to endDate: Date) -> Int {
        let start = Calendar.current.startOfDay(for: startDate)
        let end = Calendar.current.startOfDay(for: endDate)
        let diff = Calendar.current.dateComponents([.day], from: start, to: end)
        return diff.day!
    }
    
    
    
}
