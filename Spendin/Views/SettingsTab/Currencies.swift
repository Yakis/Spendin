//
//  Currencies.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 23/11/2022.
//

import SwiftUI


struct CurrenciesView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    
    var body: some View {
        VStack {
            Text("Selected currency: \(spendingVM.currency)")
            if let currencies = spendingVM.loadCurrencies() {
                List {
                    ForEach(currencies, id: \.name) { currency in
                        HStack {
                            Text(currency.name)
                                .font(.subheadline)
                                .fontWeight(.thin)
                            Spacer()
                            Text(currency.symbol_native)
                                .fontWeight(.light)
                        }
                        .onTapGesture {
                            spendingVM.currency = ""
                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                                spendingVM.currency = currency.symbol_native
                            })
                        }
                    }
                }
            }
        }
        
    }
    
    
}
