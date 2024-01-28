//
//  QRGeneratorView.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 12/07/2022.
//

import SwiftUI

struct QRGeneratorView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.spendingVM) private var spendingVM
    var image: UIImage
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text("Ask the owner of the list to scan the code bellow.")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
            }.padding()
            Image(uiImage: image)
                .resizable()
                .interpolation(.none)
                .scaledToFit()
                .frame(width: 200, height: 200)
                .cornerRadius(16)
                .padding()
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Done")
                    .padding(5)
            }
            .padding()
            .buttonStyle(.borderedProminent)
            .tint(AdaptColors.theOrange)
        }
    }
    
}
