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
    
    struct Character: Identifiable {
        private let index: Int
        private let digitValue: Int
        
        var id: Int { index }
        var colors: FillAndBorder {
            BinaryView.numberColors[digitValue]
        }
        var shapeDirection: ShapeDirection {
            index % 2 == 0 ? .up : .down
        }
        
        init(index: Int, digitValue: Int) {
            self.index = index
            self.digitValue = digitValue
        }
    }
    
    static var numberColors: [FillAndBorder] {
        switch system.colors.paletteStyle {
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
    
    // Styles
    var characterLength: CGFloat {
        switch system.basicShape {
        case .triangle, .diamond:
            return 30
        case .trapezoid:
            return 28
        default:
            return 26
        }
    }
    var spacing: CGFloat {
        switch system.basicShape {
        case .triangle:
            return -2
        case .trapezoid:
            return 2
        default:
            return 10
        }
    }
    
    // Math
    var value = 0
    var maxValue = 0
    var base = 2
    private var digits: [Int] {
        Int.representation(of: value, inBase: base, withDigitCount: Int.numberOfDigits(for: maxValue, inBase: base))
    }
    private var characters: [Character] {
        digits.enumerated().map({ Character(index: $0.offset, digitValue: $0.element) })
    }
    
    var body: some View {
        HStack(spacing: system.basicShape == .triangle ? 0 : 10) {
            ForEach(characters) { char in
                AutoShape(direction: char.shapeDirection)
                    .foregroundColor(char.colors.fill)
                    .frame(width: characterLength, height: characterLength, alignment: .center)
                    .overlay {
                        if char.colors.border != nil {
                            AutoShape(direction: char.shapeDirection)
                                .strokeBorder(Color(color: .primary, opacity: .max), lineWidth: 2)
                                .frame(width: characterLength, height: characterLength, alignment: .center)
                        }
                    }
            }
        }
        .padding(8)
    }
}

struct BinaryView_Previews: PreviewProvider {
    static var previews: some View {
        BinaryView()
    }
}
