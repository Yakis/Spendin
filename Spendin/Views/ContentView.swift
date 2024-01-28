//
//  ContentView.swift
//  Spendy
//
//  Created by Mugurel on 19/07/2020.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.spendingVM) private var spendingVM
    
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            CustomTabView()
        } else {
            NavigationView {
                SideBarView()
                SpendingsView()
            }.navigationViewStyle(DoubleColumnNavigationViewStyle())
        }
    }
    
    
}




