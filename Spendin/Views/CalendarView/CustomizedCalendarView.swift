//
//  CustomizedCalendarView.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 06/11/2021.
//

import SwiftUI

struct CustomizedCalendarView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    
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
                        guard !spendingVM.lists.isEmpty else { return }
                        selectedIndex = spendingVM.currentListIndex
                    }
                }
            }
            .background(AdaptColors.container)
            .padding(.bottom, 1)
            .navigationTitle(spendingVM.lists.isEmpty ? "" : spendingVM.lists[spendingVM.currentListIndex].name.capitalized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Picker("", selection: $selectedIndex) {
                            ForEach(0..<spendingVM.lists.count, id: \.self) { index in
                                Text(spendingVM.lists[index].name).tag(index)
                            }
                        }
                    }
                label: {
                    Image(systemName: "list.bullet.circle.fill")
                }
                }
            }
            .onChange(of: selectedIndex) { newValue in
                spendingVM.currentListIndex = newValue
            }
        }
    }
    
    
    func getCurrentMonth() -> Date {
        guard let currentMonth = calendar.dateInterval(of: .month, for: Date()) else { return Date() }
        let date = currentMonth.start
        return date
    }
    
    
}
