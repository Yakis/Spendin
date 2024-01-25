//
//  Currency.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 23/11/2022.
//

import Foundation

struct Currency : Codable {
    let symbol: String
    let name: String
    let symbol_native: String
    let decimal_digits: Int
    let rounding: Double
    let code: String
    let name_plural: String
    var icon: String
    
    
    init() {
        self.symbol = ""
        self.name = ""
        self.symbol_native = ""
        self.decimal_digits = 0
        self.rounding = 0.0
        self.code = ""
        self.name_plural = ""
        self.icon = "dollarsign"
    }
}
