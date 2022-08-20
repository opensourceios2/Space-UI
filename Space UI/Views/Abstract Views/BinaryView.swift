//
//  BinaryView.swift
//  Space UI
//
//  Created by Jayden Irwin on 2019-12-18.
//  Copyright © 2019 Jayden Irwin. All rights reserved.
//

import SwiftUI

extension Double {
    static func log(base: Double, of value: Double) -> Double {
        return log10(value) / log10(base)
    }
}

extension Int {
    static func numberOfDigits(for number: Int, inBase base: Int) -> Int {
        return Int(ceil(Double.log(base: Double(base), of: Double(1+number))))
    }
    
    static func representation(of number: Int, inBase base: Int, withDigitCount numberOfDigits: Int) -> [Int] {
        if numberOfDigits == 1 {
            return [number]
        } else {
            var array = representation(of: number/base, inBase: base, withDigitCount: numberOfDigits-1)
            array.append(number % base)
            return array
        }
    }
}

// Example of what this looks like:
// [X][X][ ][X][ ]

struct BinaryView: View {
    
    static var numberColors: [FillAndBorder] {
        switch system.paletteStyle {
        case .colorful:
            return [
                FillAndBorder(fill: Color(color: .primary, opacity: .max)),
                FillAndBorder(fill: Color(color: .secondary, opacity: .max)),
                FillAndBorder(fill: Color(color: .tertiary, opacity: .max))
            ]
        case .limited:
            return [
                (system.prefersBorders ? FillAndBorder(fill: .clear, border: Color(color: .primary, opacity: .max)) : FillAndBorder(fill: Color(color: .primary, opacity: .low))),
                FillAndBorder(fill: Color(color: .primary, opacity: .max)),
                FillAndBorder(fill: Color(color: .secondary, opacity: .max))
            ]
        case .monochrome:
            return [
                FillAndBorder(fill: .clear, border: Color(color: .primary, opacity: .max)),
                FillAndBorder(fill: Color(color: .primary, opacity: .max)),
                FillAndBorder(fill: Color(color: .primary, opacity: .medium))
            ]
        }
    }
    
    var value = 0
    var maxValue = 0
    var base = 2
    var digits: [Int] {
        Int.representation(of: value, inBase: base, withDigitCount: Int.numberOfDigits(for: maxValue, inBase: base))
    }
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<Int.numberOfDigits(for: maxValue, inBase: base)) { i in
                AutoShape(direction: i % 2 == 0 ? .up : .down)
                    .foregroundColor(BinaryView.numberColors[digits[i]].fill)
                    .frame(width: 26, height: 26, alignment: .center)
                    .overlay(
                        BinaryView.numberColors[digits[i]].border == nil ? nil :
                        AutoShape(direction: i % 2 == 0 ? .up : .down)
                            .strokeBorder(Color(color: .primary, opacity: .max), lineWidth: 2)
                            .frame(width: 26, height: 26, alignment: .center)
                    )
            }
        }.padding(8)
    }
}

struct BinaryView_Previews: PreviewProvider {
    static var previews: some View {
        BinaryView()
    }
}
