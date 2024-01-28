//
//  Currencies.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 23/11/2022.
//

import SwiftUI


struct CurrenciesView: View {
    
    @AppStorage("currency") var currency = "$"
    @Environment(\.spendingVM) private var spendingVM
    @State private var isCurrencyChanging = false
    @State private var selectedCurrency: Currency = Currency()
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            VStack {
                if let currencies = spendingVM.loadCurrencies() {
                    List {
                        ForEach(searchText.isEmpty ? currencies : currencies.filter { $0.name.lowercased().contains(searchText.lowercased()) }, id: \.name) { currency in
                            HStack {
                                Text(currency.name)
                                    .font(.subheadline)
                                    .fontWeight(.thin)
                                Spacer()
                                Text(currency.symbol_native)
                                    .fontWeight(.light)
                            }
                            .onTapGesture {
                                change(currency)
                            }
                        }
                    }
                    .overlay {
                        VStack {
                            if selectedCurrency.icon.isEmpty {
                                Text(selectedCurrency.symbol_native)
                                    .font(.system(size: 60))
                                    .padding(.bottom, 20)
                            } else {
                                Image(systemName: "\(selectedCurrency.icon).circle")
                                    .renderingMode(.original)
                                    .contentTransition(.symbolEffect(.replace))
                                    .font(.system(size: 60))
                                    .tint(.red)
                                    .padding(.bottom, 20)
                            }
                            Text(selectedCurrency.name)
                                .font(.system(size: 14))
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: 150, height: 150)
                        .padding(20)
                        .background(.secondary)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        .opacity(isCurrencyChanging ? 1 : 0)
                    }
                }
            }
            .onAppear {
                selectedCurrency = spendingVM.loadCurrencies()?.first { $0.symbol_native == currency } ?? Currency()
            }
        }
        .searchable(text: $searchText, placement: .automatic, prompt: Text("Search currencies..."))
        .navigationTitle("Currencies")
    }
    
    
    
    func change(_ currency: Currency) {
        Task {
            guard isCurrencyChanging == false else { return }
            self.currency = currency.symbol_native
            self.selectedCurrency = currency
            isCurrencyChanging = true
            try await Task.sleep(nanoseconds: 2_000_000_000)
            isCurrencyChanging = false
        }
    }
    
    
    
}
