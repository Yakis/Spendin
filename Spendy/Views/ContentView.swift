//
//  ContentView.swift
//  Spendy
//
//  Created by Mugurel on 19/07/2020.
//

import SwiftUI

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
        .onOpenURL(perform: { url in
            print(url)
        })
    }
    
    
}

struct ContentView: View {
    
    #if os(iOS)
    init() {
        UITabBar.appearance().barTintColor = UIColor(named: "Container")
        UITabBar.appearance().isTranslucent = false
    }
    #endif
    
    
    var body: some View {
        #if os(iOS)
            CustomTabView()
        #else
            CustomNavigationView()
        #endif
    }
    
    
}







struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone 11 Pro Max")
            ContentView()
                .previewDevice("iPad (7th generation)")
        }
    }
}



struct CustomTabView: View {
    
    @ObservedObject var settingsVM = SettingsVM()
    
    
    var body: some View {
        TabView {
            SpendingsView()
                .tabItem {
                    Label("Spending", systemImage: "creditcard.fill")
                }.tag(0)
            RemindersView()
                .tabItem {
                    Label("Reminders", systemImage: "clock.fill")
                }.tag(1)
            SharingView()
                .tabItem {
                    Label("Sharing", systemImage: "person.2.circle.fill")
                }.tag(2)
            SettingsView().environmentObject(settingsVM)
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
