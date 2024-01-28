//
//  ContentView.swift
//  Spendy
//
//  Created by Mugurel on 19/07/2020.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    
    
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




