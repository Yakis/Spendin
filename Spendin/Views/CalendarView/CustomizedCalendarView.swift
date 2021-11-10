//
//  CustomizedCalendarView.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 06/11/2021.
//

import SwiftUI

struct CustomizedCalendarView: View {
    
    @Environment(\.calendar) var calendar
    
    private var year: DateInterval {
        let components = DateComponents(year: 1)
        let currentYear = calendar.dateInterval(of: .year, for: Date())
        let todayNextYear = calendar.date(byAdding: components, to: Date())!
        let nextYear = calendar.dateInterval(of: .year, for: todayNextYear)
        return DateInterval(start: currentYear!.start, end: nextYear!.end)
    }
    
    var body: some View {
        ScrollView {
            ScrollViewReader { scroll in
                CalendarView(interval: year) { date in
                    Text("30")
                        .hidden()
                        .padding(8)
                        .background(AdaptColors.cellBackground)
                        .clipShape(Circle())
                        .padding(.vertical, 4)
                        .overlay(
                            Text(String(self.calendar.component(.day, from: date)))
                                .foregroundColor(AdaptColors.theOrange)
                        )
                }
                .padding()
                .onAppear {
                    scroll.scrollTo(getCurrentMonth(), anchor: .top)
                }
            }
        }
        .background(AdaptColors.container)
        .edgesIgnoringSafeArea(.top)
    }
    
    
    func getCurrentMonth() -> Date {
        guard let currentMonth = calendar.dateInterval(of: .month, for: Date()) else { return Date() }
        let date = currentMonth.start
        return date
    }
    
    
}
