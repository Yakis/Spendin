//
//  CategoryPicker.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI

struct CategoryPicker: View {
    
    var categories: [String]
    @Binding var category: String
    @State private var revealDetails: Bool = false
    
    let columns = [
        GridItem(.adaptive(minimum: 60))
    ]
    
    var body: some View {
        HStack {
            let image = Image(systemName: category)
            DisclosureGroup("Pick a category   \(image)", isExpanded: $revealDetails) {
                Spacer()
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(categories, id: \.self) { item in
                        Image(systemName: item)
                            .font(.title)
                            .foregroundColor(self.category == item ? AdaptColors.theOrange : AdaptColors.adaptText)
                            .onTapGesture {
                                withAnimation {
                                    self.category = item
                                    self.revealDetails.toggle()
                                }
                            }
                    }
                }
            }
            .font(.title)
            .accentColor(AdaptColors.theOrange)
            .padding([.top, .bottom], 20)
            .onTapGesture {
                withAnimation {
                    self.revealDetails.toggle()
                }
            }
            Spacer()
        }
    }
}
