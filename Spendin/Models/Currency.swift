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
}
