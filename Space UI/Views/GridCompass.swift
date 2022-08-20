//
//  GridCompass.swift
//  Space UI
//
//  Created by Jayden Irwin on 2020-03-30.
//  Copyright © 2020 Jayden Irwin. All rights reserved.
//

import SwiftUI

struct GridCompass: View {
    
    @State var angle = Angle.zero
    
    var body: some View {
        ZStack {
            GridShape(rows: 4, columns: 4, hasOutsideBorders: false)
                .stroke(Color(color: .primary, opacity: .max), lineWidth: 2)
                .rotationEffect(self.angle)
            
            // Crosshairs
            Rectangle()
                .foregroundColor(Color(color: .primary, opacity: .max))
                .frame(width: 3)
            Rectangle()
                .foregroundColor(Color(color: .primary, opacity: .max))
                .frame(height: 3)
            
            // Angle Marks
            Path { path in
                path.move(to: CGPoint(x: 75, y: 15))
                path.addRelativeArc(center: CGPoint(x: 75, y: 75), radius: 60, startAngle: Angle(degrees: -90), delta: Angle(degrees: 90))
                path.move(to: CGPoint(x: 75, y: 135))
                path.addRelativeArc(center: CGPoint(x: 75, y: 75), radius: 60, startAngle: Angle(degrees: 90), delta: Angle(degrees: 90))
            }
            .stroke(Color(color: .primary, opacity: .max), style: StrokeStyle(lineWidth: 10, dash: [3, 15], dashPhase: 10))
            
            Triangle()
                .environment(\.shapeDirection, .up)
                .foregroundColor(Color(color: .primary, opacity: .max))
                .frame(width: 30, height: 30)
            Triangle()
                .stroke(Color(color: .primary, opacity: .min), lineWidth: 2)
                .environment(\.shapeDirection, .up)
                .frame(width: 30, height: 30)
            
            Circle()
                .strokeBorder(Color(color: .primary, opacity: .max), lineWidth: 2)
        }
        .clipShape(Circle())
        .task {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
                withAnimation(Animation.easeInOut(duration: 1)) {
                    self.angle = Angle(degrees: Double.random(in: -20...20))
                }
            }
        }
    }
}

struct GridCompass_Previews: PreviewProvider {
    static var previews: some View {
        GridCompass()
    }
}
