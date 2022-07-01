//
//  SpendingsForDateView.swift
//  Spendy
//
//  Created by Mugurel on 17/11/2020.
//

import SwiftUI

struct SpendingsForDateView: View {
    
    @Environment(\.calendar) var calendar
    @EnvironmentObject var spendingVM: SpendingVM
    @Binding var selectedDate: Date
    @State private var isUpdate: Bool = false
    @State private var showModal: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            Text(selectedDate.shortString())
                .font(.title2)
                .foregroundColor(AdaptColors.theOrange)
                .padding()
            List {
                ForEach(spendingVM.currentListItems.filter { calendar.compare($0.date, to: selectedDate, toGranularity: .day) == .orderedSame} , id: \.id) { item in
                    DetailedListItemCell(item: item, index: 0, isUpdate: $isUpdate, showModal: $showModal)
                        .environmentObject(spendingVM)
                }
                .listRowBackground(AdaptColors.cellBackground)
            }
            .frame(maxHeight: spendingVM.currentListItems.filter { calendar.compare($0.date, to: selectedDate, toGranularity: .day) == .orderedSame}.isEmpty ? 0 : .infinity)
            .opacity(spendingVM.currentListItems.filter { calendar.compare($0.date, to: selectedDate, toGranularity: .day) == .orderedSame}.isEmpty ? 0 : 1)
            Text("Nothing today")
                .font(.callout)
                .fontWeight(.bold)
                .frame(maxHeight: spendingVM.currentListItems.filter { calendar.compare($0.date, to: selectedDate, toGranularity: .day) == .orderedSame}.isEmpty ? .infinity : 0)
                .opacity(spendingVM.currentListItems.filter { calendar.compare($0.date, to: selectedDate, toGranularity: .day) == .orderedSame}.isEmpty ? 0.6 : 0)
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
            .sheet(isPresented: $showModal) {
                AddSpenderView(isUpdate: $isUpdate, date: $selectedDate)
                    .environmentObject(spendingVM)
            }
        }
        .padding()
    }
    
    
    
    
    
    
}

