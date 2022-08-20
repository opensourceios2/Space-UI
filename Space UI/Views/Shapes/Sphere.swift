//
//  Sphere.swift
//  Space UI
//
//  Created by Jayden Irwin on 2019-12-30.
//  Copyright © 2019 Jayden Irwin. All rights reserved.
//

import SwiftUI

struct Sphere: Shape {
    
    let vertical: Int
    let horizontal: Int
    
    func path(in rect: CGRect) -> Path {
        let length = min(rect.width, rect.height)
        let square = CGRect(x: rect.midX - length/2, y: rect.midY - length/2, width: length, height: length)
        
        return Path { path in
            path.addEllipse(in: square)
            
            if horizontal != 0 {
                for step in 1...horizontal {
                    let fraction = CGFloat(step) / CGFloat(horizontal+1)
                    let x = sqrt(pow(square.width/2, 2) - pow((fraction-0.5) * square.width, 2))
                    let y = square.minY + fraction * square.height
                    
                    path.move(to: CGPoint(x: square.midX - x, y: y))
                    path.addLine(to: CGPoint(x: square.midX + x, y: y))
                }
            }
            
            if vertical != 0 {
                for step in 1...vertical/2 {
                    let fraction = CGFloat(step) / CGFloat(vertical)
                    let ellipseRect = square.applying(CGAffineTransform(scaleX: cos(.pi * fraction), y: 1))
                    path.addEllipse(in: ellipseRect.applying(CGAffineTransform(translationX: square.midX - ellipseRect.midX, y: 0)))
                }
                if vertical % 2 == 0 {
                    path.move(to: CGPoint(x: square.midX, y: square.minY))
                    path.addLine(to: CGPoint(x: square.midX, y: square.maxY))
                }
            }
        }
    }
}

struct Sphere_Previews: PreviewProvider {
    static var previews: some View {
        Sphere(vertical: 7, horizontal: 7).stroke()
    }
}