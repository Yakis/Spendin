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
    var proxy: GeometryProxy
    @FetchRequest(entity: CDList.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CDList.created, ascending: true)])
    var lists: FetchedResults<CDList>
    var currentList: CDList
    @Binding var participants: Dictionary<NSManagedObject, [ShareParticipant]>
    @Binding var showDetailedList: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(currentList.title ?? "")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(AdaptColors.theOrange)
                .padding()
            ShareInfoView(list: currentList, participants: participants)
                .opacity(0.8)
            VStack(alignment: currentList.itemsArray.isEmpty ? .center : .leading) {
                switch currentList.itemsArray.count {
                case 0:
                    Text("Empty list, \ntap to add items.")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .opacity(0.5)
                        .frame(width: proxy.size.width / 1.3, height: proxy.size.height / 2, alignment: .center)
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
            Spacer()
            Rectangle()
                .frame(width: proxy.size.width / 1.3, height: 10, alignment: .bottom)
                .foregroundColor(AdaptColors.theOrange)
        }
        .frame(width: proxy.size.width / 1.3, height: proxy.size.height / 1.3, alignment: .leading)
        .background(.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .tag(lists.firstIndex(of: currentList))
        .onTapGesture {
            withAnimation {
                guard let index = spendingVM.currentIndex else { return }
                spendingVM.currentList = lists[index]
                showDetailedList = true
            }
        }
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
