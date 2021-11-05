//
//  CalendarView.swift
//  Spendy
//
//  Created by Mugurel on 16/11/2020.
//

import SwiftUI

struct CalendarView<DateView>: View where DateView: View {
    
    @Environment(\.calendar) var calendar
    
    let interval: DateInterval
    let content: (Date) -> DateView
    
    
    init(
        interval: DateInterval,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self.interval = interval
        self.content = content
    }
    
    
    private var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ScrollViewReader { value in
                VStack(alignment: .center) {
                    ForEach(months, id: \.self) { month in
                        Text("\(month.shortString())")
                            .font(.title)
                            .multilineTextAlignment(.center)
                        MonthView(month: month, content: self.content)
                            .frame(alignment: .center)
                            .padding(.bottom, 20)
                            .onAppear(perform: {
                                value.scrollTo(getCurrentMonth(), anchor: .top)
                            })
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(1)
    }
    
    
    
    func getCurrentMonth() -> Date {
        guard let currentMonth = calendar.dateInterval(of: .month, for: Date()) else { return Date() }
        let date = currentMonth.start
        return date
    }
    
    
}



struct MonthView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    
    let month: Date
    let content: (Date) -> DateView
    
    init(
        month: Date,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self.month = month
        self.content = content
    }
    
    private var weeks: [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month)
        else { return [] }
        return calendar.generateDates(
            inside: monthInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: Calendar.current.firstWeekday)
        )
    }
    
    var body: some View {
        VStack {
            ForEach(weeks, id: \.self) { week in
                WeekView(week: week, content: self.content)
            }
        }
    }
}





struct WeekView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    
    let week: Date
    let content: (Date) -> DateView
    @State private var showTodaySpendings: Bool = false
    @State private var selectedDate: Date = Date()
    
    init(
        week: Date,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self.week = week
        self.content = content
    }
    
    private var days: [Date] {
        guard
            let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week)
        else { return [] }
        
        return calendar.generateDates(
            inside: weekInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
    
    var body: some View {
        HStack {
            ForEach(days, id: \.self) { date in
                HStack {
                    if self.calendar.isDate(self.week, equalTo: date, toGranularity: .month) {
                        self.content(date)
                            .onTapGesture {
                                selectedDate = date
                                showTodaySpendings = true
                            }
                            .sheet(isPresented: $showTodaySpendings, content: {
                                SpendingsForDateView(selectedDate: $selectedDate)
                                    .background(AdaptColors.container)
                                    .edgesIgnoringSafeArea(.all)
                            })
                    } else {
                        self.content(date).hidden()
                    }
                }
            }
        }
    }
}




fileprivate extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)
        
        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }
        
        return dates
    }
}
