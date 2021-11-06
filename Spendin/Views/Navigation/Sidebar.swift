//
//  Sidebar.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 06/11/2021.
//

import SwiftUI

enum NavElements: CaseIterable {
    case spending
    case calendar
    case sharing
    case settings
    
    var title: String {
        switch self {
        case .spending:
            return "Spending"
        case .calendar:
            return "Calendar"
        case .sharing:
            return "Sharing"
        case .settings:
            return "Settings"
        }
    }
    
    
    var image: String {
        switch self {
        case .spending:
            return "creditcard"
        case .calendar:
            return "calendar"
        case .sharing:
            return "person.2.circle"
        case .settings:
            return "gear"
        }
    }
    
}


struct SideBarView: View {
    
    
    
    
    var body: some View {
        List(NavElements.allCases, id: \.self) { element in
            switch element {
            case .spending:
                NavigationLink(destination: SpendingsView()) {
                    Label(element.title, systemImage: element.image)
                }
            case .calendar:
                NavigationLink(destination: CustomizedCalendarView()) {
                    Label(element.title, systemImage: element.image)
                }
            case .sharing:
                NavigationLink(destination: SharingView()) {
                    Label(element.title, systemImage: element.image)
                }
            case .settings:
                NavigationLink(destination: SettingsView()) {
                    Label(element.title, systemImage: element.image)
                }
            }
        }.listStyle(SidebarListStyle())
    }
    
    
}
