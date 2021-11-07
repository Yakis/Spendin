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
                ForEach(spendingVM.items.filter { calendar.compare($0.date, to: selectedDate, toGranularity: .day) == .orderedSame}, id: \.id) { item in
                    SpendingsListCell(item: item, isUpdate: $isUpdate, showModal: $showModal)
                        .environmentObject(spendingVM)
                }
                .listRowBackground(AdaptColors.cellBackground)
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
            .sheet(isPresented: $showModal) {
                AddSpenderView(isUpdate: $isUpdate, date: selectedDate)
                    .environmentObject(spendingVM)
            }
            .onAppear(perform: {
                print(selectedDate)
            })
        }
        .padding()
    }
    
    
    
    
    
    
}

