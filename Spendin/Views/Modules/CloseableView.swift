//
//  CloseableView.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 03/07/2022.
//

import SwiftUI

struct CloseableView<Content>: View where Content: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var title: String?
    var content: () -> Content
    
    var body: some View {
        VStack {
            ZStack {
                if let title = title {
                    Text(title)
                        .font(.body)
                        .fontWeight(.semibold)
                        .frame(alignment: .center)
                }
                HStack {
                    Spacer()
                Image(systemName: "xmark.circle")
                    .font(.title2)
                    .foregroundColor(AdaptColors.theOrange)
                    .frame(alignment: .trailing)
                    .padding(.trailing, 20)
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            content()
        }.background(Color.clear)
    }
}
