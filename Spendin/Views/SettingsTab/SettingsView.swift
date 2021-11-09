//
//  SettingsView.swift
//  Spendtrack
//
//  Created by Mugurel Moscaliuc on 10/07/2020.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    
    var body: some View {
        VStack {
            Text("Delete suggestions")
                .padding()
            Button {
                spendingVM.deleteSuggestions()
            } label: {
                Text("Delete")
            }.buttonStyle(.borderedProminent)
        }
    }
}

