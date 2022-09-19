//
//  AlmostThereNumberText.swift
//  Space UI
//
//  Created by Jayden Irwin on 2022-01-11.
//  Copyright © 2022 Jayden Irwin. All rights reserved.
//

import SwiftUI

struct AlmostThereNumberText: View {
    
    @Binding var number: Int
    let digitCount: Int
    let fontSize: CGFloat = system.defaultFontSize * 2
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Text(String(repeating: "0", count: digitCount))
                .font(Font.custom(Font.Name.almostThere.rawValue, size: fontSize))
                .foregroundColor(Color(color: .primary, opacity: .low))
            Text(String(number))
                .font(Font.custom(Font.Name.almostThere.rawValue, size: fontSize))
                .foregroundColor(Color(color: .secondary, opacity: .max))
        }
        .fixedSize()
    }
}

struct AlmostThereNumberText_Previews: PreviewProvider {
    static var previews: some View {
        AlmostThereNumberText(number: .constant(12345), digitCount: 5)
    }
}
