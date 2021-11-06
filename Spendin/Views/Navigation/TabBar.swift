//
//  TabBar.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 06/11/2021.
//

import SwiftUI


struct CustomTabView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    
    var body: some View {
        TabView {
            SpendingsView()
                .environmentObject(spendingVM)
                .tabItem {
                    Label(NavElements.spending.title, systemImage: NavElements.spending.image)
                }.tag(0)
            CustomizedCalendarView()
                .environmentObject(spendingVM)
                .tabItem {
                    Label(NavElements.calendar.title, systemImage: NavElements.calendar.image)
                }.tag(1)
            SharingView()
                .tabItem {
                    Label(NavElements.sharing.title, systemImage: NavElements.sharing.image)
                }.tag(2)
            SettingsView()
                .tabItem {
                    Label(NavElements.settings.title, systemImage: NavElements.settings.image)
                }.tag(3)
        }
        .accentColor(AdaptColors.theOrange)
        .background(AdaptColors.container)
    }
}
