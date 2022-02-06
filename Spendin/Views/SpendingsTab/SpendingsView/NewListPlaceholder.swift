//
//  NewListPlaceholder.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 06/02/2022.
//

import SwiftUI


struct NewListPlaceholder: View {
    
    @Binding var showNewListView: Bool
    var importAction: () -> ()
    
    var body: some View {
        VStack {
            Text("Add a new list")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .opacity(0.5)
                .padding()
            Button {
                showNewListView = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
            }
            Text("or import from file")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .opacity(0.5)
                .padding()
            Button {
                importAction()
            } label: {
                Image(systemName: "arrow.up.doc.fill")
                    .font(.title)
            }
            
        }
    }
}
