//
//  AccessoryRectangularWidgetView.swift
//  Spendin WidgetExtension
//
//  Created by Mugurel Moscaliuc on 14/09/2022.
//

import SwiftUI

struct AccessoryRectangularWidgetView: View {
    
    var body: some View {
        HStack {
            Image("logo")
                .resizable()
                .frame(width: 30, height: 30)
                .widgetAccentable()
            VStack {
                Text("Sept-Oct").font(.caption)
                Text("Total: £10").font(.caption2)
            }
        }
    }
    
    
}
