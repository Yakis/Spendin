//
//  CustomizedCalendarView.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 06/11/2021.
//

import SwiftUI

struct CustomizedCalendarView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    
    @FetchRequest(entity: CDList.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CDList.created, ascending: true)])
    var lists: FetchedResults<CDList>
    
    @State private var selectedIndex: Int = 0
    
    @Environment(\.calendar) var calendar
    
    @State private var showListPicker = false
    
    private var year: DateInterval {
        let components = DateComponents(year: 1)
        let currentYear = calendar.dateInterval(of: .year, for: Date())
        let todayNextYear = calendar.date(byAdding: components, to: Date())!
        let nextYear = calendar.dateInterval(of: .year, for: todayNextYear)
        return DateInterval(start: currentYear!.start, end: nextYear!.end)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                ScrollViewReader { scroll in
                    CalendarView(interval: year) { date in
                        Text("30")
                            .hidden()
                            .padding(8)
                            .background(date.isToday() ? AdaptColors.theOrange : AdaptColors.cellBackground)
                            .clipShape(Circle())
                            .padding(.vertical, 4)
                            .overlay(
                                Text(String(self.calendar.component(.day, from: date)))
                                    .foregroundColor(date.isToday() ? .white : AdaptColors.theOrange)
                            )
                    }
                    .padding()
                    .onAppear {
                        scroll.scrollTo(getCurrentMonth(), anchor: .top)
                    }
                }
            }
            .background(AdaptColors.container)
            .padding(.bottom, 1)
            .navigationTitle(spendingVM.currentList?.title?.capitalized ?? "Nothing")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Picker("", selection: $selectedIndex) {
                            ForEach(0..<lists.count, id: \.self) { index in
                                Text(lists[index].title ?? "").tag(index)
                            }
                        }
                    }
                label: {
                    Image(systemName: "list.bullet.circle.fill")
                }
                }
            }
            .onChange(of: selectedIndex) { newValue in
                spendingVM.currentList = lists[selectedIndex]
            }
        }
    }
    
    
    func getCurrentMonth() -> Date {
        guard let currentMonth = calendar.dateInterval(of: .month, for: Date()) else { return Date() }
        let date = currentMonth.start
        return date
    }
    
    
}
