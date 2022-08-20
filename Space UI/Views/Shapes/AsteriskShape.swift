//
//  AsteriskShape.swift
//  Space UI
//
//  Created by Jayden Irwin on 2019-12-22.
//  Copyright © 2019 Jayden Irwin. All rights reserved.
//

import SwiftUI

struct AsteriskShape: Shape {
    
    var lineEnds: Int
    
    func path(in rect: CGRect) -> Path {
        let pi2 = CGFloat.pi * 2.0
        let radius = min(rect.width, rect.height)/2
        
        return Path { path in
            if lineEnds % 2 == 0 {
                for lineNumber in 0..<(lineEnds/2) {
                    let start = pi2 * CGFloat(lineNumber) / CGFloat(lineEnds)
                    path.move(to: CGPoint(x: rect.midX +  radius * cos(start), y: rect.midY + radius * sin(start)))
                    let end = pi2 * (CGFloat(lineEnds) / 2 + CGFloat(lineNumber)) / CGFloat(lineEnds)
                    path.addLine(to: CGPoint(x: rect.midX + radius * cos(end), y: rect.midY + radius * sin(end)))
                }
            } else {
                let center = CGPoint(x: rect.midX, y: rect.midY)
                for lineNumber in 0..<lineEnds {
                    path.move(to: center)
                    let end = (pi2 * (CGFloat(lineEnds) / 2 + CGFloat(lineNumber)) / CGFloat(lineEnds)) - .pi/2
                    path.addLine(to: CGPoint(x: rect.midX + radius * cos(end), y: rect.midY + radius * sin(end)))
                }
            }
        }
    }
}

struct AsteriskShape_Previews: PreviewProvider {
    static var previews: some View {
        AsteriskShape(lineEnds: 30)
    }
}
