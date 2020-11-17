//
//  ContentView.swift
//  Spendy
//
//  Created by Mugurel on 19/07/2020.
//

import SwiftUI
import CoreData

struct NavElement {
    let id = UUID()
    var title: String
    var image: String
}


struct SideBarView: View {
    
    var navElements = [
        NavElement(title: "Spending", image: "creditcard.fill"),
        NavElement(title: "Reminders", image: "clock.fill"),
        NavElement(title: "Sharing", image: "person.2.circle.fill"),
        NavElement(title: "Settings", image: "gear")
    ]
    
    
    var body: some View {
        List(navElements, id: \.id) { element in
            Label(element.title, systemImage: element.image)
        }.listStyle(SidebarListStyle())
    }
    
    
}

struct ContentView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    
    #if os(iOS)
    init() {
        UITabBar.appearance().barTintColor = UIColor(named: "Container")
        UITabBar.appearance().isTranslucent = false
    }
    #endif
    
    
    var body: some View {
        #if os(iOS)
        CustomTabView()
            .environmentObject(spendingVM)
        #else
            CustomNavigationView()
        #endif
    }
    
    
}





struct CustomTabView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    
    var body: some View {
        TabView {
            SpendingsView()
                .environmentObject(spendingVM)
                .tabItem {
                    Label("Spending", systemImage: "creditcard.fill")
                }.tag(0)
            CustomizedCalendarView()
                .environmentObject(spendingVM)
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }.tag(1)
            SharingView()
                .tabItem {
                    Label("Sharing", systemImage: "person.2.circle.fill")
                }.tag(2)
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }.tag(3)
        }
        .accentColor(AdaptColors.theOrange)
        .background(AdaptColors.container)
    }
        }




struct CustomNavigationView: View {
    
    
    var body: some View {
        NavigationView {
            SideBarView()
            SpendingsView()
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
        }



struct CustomizedCalendarView: View {
    
    @Environment(\.calendar) var calendar
    
    private var year: DateInterval {
        calendar.dateInterval(of: .year, for: Date())!
    }
    
    var body: some View {
        CalendarView(interval: year) { date in
            Text("30")
                .hidden()
                .padding(8)
                .background(Color.secondary)
                .clipShape(Circle())
                .padding(.vertical, 4)
                .overlay(
                    Text(String(self.calendar.component(.day, from: date)))
                        .foregroundColor(AdaptColors.theOrange)
                )
        }
    }
}

