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
    
    var body: some View {
        VStack {
            Text(selectedDate.shortString())
                .font(.title2)
                .foregroundColor(AdaptColors.theOrange)
                .padding()
            List {
                ForEach(spendingVM.items.filter { calendar.compare($0.date, to: selectedDate, toGranularity: .day) == .orderedSame}, id: \.id) { item in
                    HStack {
                        Image(systemName: item.category)
                            .font(.title2)
                        Text(item.name)
                            .font(.custom("HelveticaNeue-Regular", size: 20))
                            .padding()
                        Text("\(String(format: "%.2f", item.amount))")
                            .font(.custom("HelveticaNeue-Light", size: 14))
                            .padding()
                    }.padding()
                }
            }
            .onAppear(perform: {
                print(selectedDate)
            })
        }.padding()
    }
    
    
    
    
    
    
}

struct SpendingsForDateView_Previews: PreviewProvider {
    static var previews: some View {
        SpendingsForDateView(selectedDate: .constant(Date()))
    }
}
