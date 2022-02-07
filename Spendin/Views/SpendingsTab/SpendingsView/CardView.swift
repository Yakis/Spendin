//
//  CardView.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 06/02/2022.
//

import SwiftUI
import CoreData

struct CardView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    var geometry: GeometryProxy
    @FetchRequest(entity: CDList.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CDList.created, ascending: true)])
    var lists: FetchedResults<CDList>
    var currentList: CDList
    @Binding var participants: Dictionary<NSManagedObject, [ShareParticipant]>
    @Binding var showDetailedList: Bool
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(currentList.title ?? "")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding([.leading, .bottom])
                    .frame(width: geometry.size.width / 1.3, alignment: .leading)
                ShareInfoView(list: currentList, participants: participants)
                    .opacity(0.8)
            }
            .frame(width: geometry.size.width / 1.3, height: geometry.size.height / 4, alignment: .center)
            .background(AdaptColors.theOrange)
            Spacer()
            CardListContentView(currentList: currentList, geometry: geometry)
            Spacer()
            Rectangle()
                .frame(width: geometry.size.width / 1.3, height: 10, alignment: .center)
                .foregroundColor(AdaptColors.theOrange)
        }
        .frame(width: geometry.size.width / 1.3, height: geometry.size.height / 1.3, alignment: .center)
        .background(AdaptColors.container)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onTapGesture {
            withAnimation {
                spendingVM.currentList = lists[spendingVM.currentIndex]
                showDetailedList = true
            }
        }
    }
    
    
}



struct CardListContentView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    var currentList: CDList
    var geometry: GeometryProxy
    
    
    var body: some View {
        VStack(alignment: currentList.itemsArray.isEmpty ? .center : .leading) {
            switch currentList.itemsArray.count {
            case 0:
                Text("Empty list, \ntap to add items.")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .opacity(0.5)
                    .frame(width: geometry.size.width / 1.3, height: geometry.size.height / 2, alignment: .center)
                    .offset(x: -16, y: 0)
            case 1...10:
                ForEach(0..<currentList.items!.count, id: \.self) { index in
                    CardItem(list: currentList, index: index)
                }
            case 11...Int.max:
                ForEach(0..<10, id: \.self) { index in
                    CardItem(list: currentList, index: index)
                }
                Text("...\(currentList.itemsArray.count - 10) more items")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .opacity(0.5)
                    .padding(.top, 2)
            default: EmptyView()
            }
            Text("Amount left: \(String(format: "%.2f", spendingVM.total))")
                .font(.callout)
                .fontWeight(.bold)
                .padding(.top, 5)
                .opacity(currentList.itemsArray.isEmpty ? 0 : 1)
        }
        .shadow(radius: 2)
        .padding()
    }
    
}



struct CardItem: View {
    
    var list: CDList
    var index: Int
    
    var body: some View {
        HStack {
            Text(list.itemsArray[index].name ?? "")
                .font(.caption)
            Spacer()
            Text("£ \(String(format: "%.2f", list.itemsArray[index].amount))")
                .font(.caption)
        }
    }
}
