//
//  SpendingsForDateView.swift
//  Spendy
//
//  Created by Mugurel on 17/11/2020.
//

import SwiftUI

struct SpendingsForDateView: View {
    
    @Environment(\.calendar) var calendar
    @Environment(\.spendingVM) private var spendingVM
    @Binding var selectedDate: Date
    @State private var isUpdate: Bool = false
    @State private var showModal: Bool = false
    var list: ItemList
    
    var body: some View {
        if let items = list.items?.filter({ calendar.compare($0.due, to: selectedDate, toGranularity: .day) == .orderedSame}) {
            VStack(alignment: .center) {
                Text(selectedDate.shortString())
                    .font(.title2)
                    .foregroundColor(AdaptColors.theOrange)
                    .padding()
                List {
                    ForEach(items, id: \.id) { item in
                        DetailedListItemCell(item: spendingVM.itemToSave!, isUpdate: $isUpdate, showModal: $showModal)
                    }
                    .listRowBackground(AdaptColors.cellBackground)
                }
                .frame(maxHeight: items.isEmpty ? 0 : .infinity)
                .opacity(items.isEmpty ? 0 : 1)
                Text("Nothing today")
                    .font(.callout)
                    .fontWeight(.bold)
                    .frame(maxHeight: items.isEmpty ? .infinity : 0)
                    .opacity(items.isEmpty ? 0.6 : 0)
                    .sheet(isPresented: $showModal) {
                        AddSpenderView(isUpdate: $isUpdate, list: list)
                    }
                HStack {
                    Spacer()
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60, alignment: .center)
                        .foregroundColor(AdaptColors.theOrange)
                        .shadow(radius: 2)
                        .transition(.scale)
                        .padding([.trailing, .bottom], 20)
                }
                .onTapGesture {
                    showModal.toggle()
                }
            }
            .padding()
        } else {
            EmptyView()
        }
    }
    
    
    
    
    
}

