//
//  XMarkView.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI

struct XmarkView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: SpendingVM
    
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: "xmark")
                .resizable()
                .frame(width: 20, height: 20, alignment: .trailing)
                .padding(.all, 30)
                .foregroundColor(Color.init("Adapt Text"))
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                    viewModel.itemToUpdate = nil
                }
        }
    }
}
