//
//  ContentView.swift
//  Spendy
//
//  Created by Mugurel on 19/07/2020.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    
        init() {
            if UIDevice.current.userInterfaceIdiom == .phone {
            UITabBar.appearance().barTintColor = UIColor(named: "Container")
            UITabBar.appearance().isTranslucent = false
        }
    }
    
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            CustomTabView()
                .environmentObject(spendingVM)
        } else {
            NavigationView {
                SideBarView()
                SpendingsView()
            }.navigationViewStyle(DoubleColumnNavigationViewStyle())
        }
    }
    
    
}




