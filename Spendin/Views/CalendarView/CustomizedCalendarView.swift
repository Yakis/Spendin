//
//  CustomizedCalendarView.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 06/11/2021.
//

import SwiftUI
import SwiftData

struct CustomizedCalendarView: View {
    
    @Environment(\.spendingVM) private var spendingVM
    
    @State private var selectedList: String = ""
    
    @Environment(\.calendar) var calendar
    
    @State private var showListPicker = false
    @Query private var lists: [ItemList]
    
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
                    VStack {
//                        if let currentList = lists.first { $0.id == selectedList } {
                        CalendarView(interval: year, list: lists.first { $0.name == selectedList } ?? ItemList(name: "")) { date in
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
//                        }
                    }
                    .onAppear {
                        scroll.scrollTo(getCurrentMonth(), anchor: .top)
                        if let currentList = lists.first {
                            self.selectedList = currentList.name
                        }
                    }
                }
            }
            .background(AdaptColors.container)
            .padding(.bottom, 1)
            .navigationTitle((lists.isEmpty ? "" : lists.first { $0.name == selectedList }?.name) ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Picker("", selection: $selectedList) {
                            ForEach(lists, id: \.id) { list in
                                Text(list.name).tag(list.id)
                            }
                        }
                    }
                label: {
                    Image(systemName: "list.bullet.circle.fill")
                        .foregroundColor(lists.isEmpty ? .gray : AdaptColors.theOrange)
                }.disabled(lists.isEmpty)
                }
            }
            .onChange(of: selectedList) { oldValue, newValue in
                print("List changed: \(String(describing: lists.first {$0.name == selectedList}?.name))")
            }
        }
    }
    
    
    func getCurrentMonth() -> Date {
        guard let currentMonth = calendar.dateInterval(of: .month, for: Date()) else { return Date() }
        let date = currentMonth.start
        return date
    }
    
    
}
