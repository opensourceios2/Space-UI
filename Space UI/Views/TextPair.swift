//
//  TextPair.swift
//  Space UI
//
//  Created by Jayden Irwin on 2020-03-16.
//  Copyright © 2020 Jayden Irwin. All rights reserved.
//

import SwiftUI

struct TextPair: View {
    
    var prefersMonochrome: Bool = Bool.random()
    var monochrome: Bool {
        prefersMonochrome || system.paletteStyle == .monochrome
    }
    var label: String
    var value: String
    var largerFontSize: CGFloat = system.defaultFontSize
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(Font.spaceFont(size: largerFontSize * 0.8))
                .foregroundColor(monochrome ? Color(color: .primary, opacity: .medium) : Color(color: .primary, opacity: .max))
            Text(value)
                .font(Font.spaceFont(size: largerFontSize))
                .foregroundColor(monochrome ? Color(color: .primary, opacity: .max) : Color(color: .secondary, opacity: .max))
        }
        .padding(.vertical, 2)
    }
}

struct TextPair_Previews: PreviewProvider {
    static var previews: some View {
        TextPair(prefersMonochrome: Bool.random(), label: "Name", value: "Steve")
    }
}
