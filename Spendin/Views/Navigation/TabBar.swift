//
//  TabBar.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 06/11/2021.
//

import SwiftUI
import SwiftData

struct CustomTabView: View {
    
    @State private var tabSelection: Int = 0
    @Query private var lists: [ItemList]
    
    var body: some View {
        TabView(selection: $tabSelection) {
            SpendingsView()
                .tabItem {
                    Label(NavElements.spending.title, systemImage: NavElements.spending.image)
                }.tag(0)
            CustomizedCalendarView()
                .tabItem {
                    Label(NavElements.calendar.title, systemImage: NavElements.calendar.image)
                }.tag(1)
            SettingsView()
                .tabItem {
                    Label(NavElements.settings.title, systemImage: NavElements.settings.image)
                }.tag(2)
        }
        .accentColor(AdaptColors.theOrange)
        .background(AdaptColors.container)
    }
}
