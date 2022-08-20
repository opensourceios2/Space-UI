//
//  SpaceButtonStyle.swift
//  Space UI
//
//  Created by Jayden Irwin on 2019-12-15.
//  Copyright © 2019 Jayden Irwin. All rights reserved.
//

import SwiftUI

struct FlexButtonStyle: ButtonStyle {
    
    var isSelected: Bool = false
    var isDisabled: Bool = false
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .lineLimit(1)
            .accentColor(Color(color: .secondary, opacity: .max))
            .foregroundColor(Color(color: .secondary, opacity: .max))
            .multilineTextAlignment(.center)
            .padding(12)
            .frame(height: system.flexButtonFrameHeight)
            .frame(minWidth: system.flexButtonFrameHeight)
            .background(self.isDisabled ? .clear : (self.isSelected ? Color(color: .tertiary, brightness: .medium) : Color(color: .primary, brightness: .low)))
            .cornerRadius(system.cornerRadius(forLength: system.flexButtonFrameHeight))
            .overlay(
                system.prefersButtonBorders ?
                RoundedRectangle(cornerRadius: system.cornerRadius(forLength: system.flexButtonFrameHeight))
                    .strokeBorder(Color(color: self.isSelected ? .tertiary : .primary, brightness: self.isDisabled ? .medium : .max), lineWidth: 2)
                : nil
            )
            .opacity(configuration.isPressed ? 0.5 : 1.0)
            .fixedSize()
    }
}

struct ShapeButtonStyle: ButtonStyle {
    
    let shapeDirection: ShapeDirection
    
    var isSelected: Bool = false
    var isDisabled: Bool = false
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .lineLimit(1)
            .accentColor(Color(color: .secondary, opacity: .max))
            .foregroundColor(Color(color: .secondary, opacity: .max))
            .multilineTextAlignment(.center)
            .padding(buttonTextPadding())
            .frame(width: system.shapeButtonFrameWidth, height: system.shapeButtonFrameHeight)
            .background(self.isDisabled ? .clear : (self.isSelected ? Color(color: .tertiary, brightness: .medium) : Color(color: .primary, brightness: .low)))
            .clipShape(AutoShape(direction: shapeDirection))
            .overlay(
                system.prefersButtonBorders ?
                AutoShape(direction: shapeDirection)
                    .strokeBorder(Color(color: self.isSelected ? .tertiary : .primary, brightness: self.isDisabled ? .medium : .max), lineWidth: 2)
                : nil
            )
            .opacity(configuration.isPressed ? 0.5 : 1.0)
    }
    
    func buttonTextPadding() -> CGFloat {
        switch system.basicShape {
        case .triangle:
            return 22
        case .trapezoid:
            return 18
        case .diamond:
            return 14
        default:
            return 12
        }
    }
    
}

struct SpaceButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Button(action: { }) {
                Text("Hello")
            }.buttonStyle(FlexButtonStyle())
            Button(action: { }) {
                Text("Hello")
            }.buttonStyle(ShapeButtonStyle(shapeDirection: .up))
        }
    }
}
