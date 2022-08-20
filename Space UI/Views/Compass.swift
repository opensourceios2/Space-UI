//
//  Compass.swift
//  Space UI
//
//  Created by Jayden Irwin on 2020-03-19.
//  Copyright © 2020 Jayden Irwin. All rights reserved.
//

import SwiftUI

struct Compass: View {
    
    @State var angle = Angle.zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Outer Circles
                Circle()
                    .stroke(Color(color: .primary, opacity: .high), lineWidth: 2)
                Circle()
                    .stroke(Color(color: .primary, opacity: .max), style: StrokeStyle(lineWidth: 20, dash: [2, 9], dashPhase: 1))
                Circle()
                    .stroke(Color(color: .primary, opacity: .max), style: StrokeStyle(lineWidth: 10, dash: [1, 10], dashPhase: 6))
                
                // Crosshairs
                Rectangle()
                    .foregroundColor(Color(color: .primary, opacity: .max))
                    .frame(width: 2)
                Rectangle()
                    .foregroundColor(Color(color: .primary, opacity: .max))
                    .frame(height: 2)
                
                // Horizontal Tick Lines
                HStack(spacing: 20) {
                    Rectangle()
                        .foregroundColor(Color(color: .primary, opacity: .max))
                        .frame(width: 1, height: 12)
                    Rectangle()
                        .foregroundColor(Color(color: .primary, opacity: .max))
                        .frame(width: 1, height: 20)
                    Rectangle()
                        .foregroundColor(Color(color: .primary, opacity: .max))
                        .frame(width: 1, height: 12)
                    Rectangle()
                        .foregroundColor(Color(color: .primary, opacity: .max))
                        .frame(width: 1, height: 12)
                    Rectangle()
                        .foregroundColor(Color(color: .primary, opacity: .max))
                        .frame(width: 1, height: 20)
                    Rectangle()
                        .foregroundColor(Color(color: .primary, opacity: .max))
                        .frame(width: 1, height: 12)
                }
                
                // Inner Circles
                ZStack {
                    PieSlice(deltaAngle: .pi, hasRadialLines: false)
                        .foregroundColor(Color(color: .primary, opacity: .max))
                        .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.5)
                        .rotationEffect(Angle(radians: .pi))
                        .offset(x: 0, y: geometry.size.height * 0.25)
                    Circle()
                        .stroke(Color(color: .primary, opacity: .max), lineWidth: 1)
                        .frame(width: geometry.size.width * 0.25, height: geometry.size.height * 0.25)
                    Circle()
                        .stroke(Color(color: .secondary, opacity: .max), lineWidth: 2)
                        .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.4)
                    Circle()
                        .stroke(Color(color: .primary, opacity: .max), lineWidth: 1)
                        .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.5)
                    Triangle()
                        .environment(\.shapeDirection, .up)
                        .foregroundColor(Color(color: .primary, opacity: .max))
                        .frame(width: 20, height: 20)
                        .offset(x: 0, y: -geometry.size.height * 0.65)
                }
            }
            .position(x: geometry.size.width/2, y: geometry.size.height/2)
        }
        .rotationEffect(self.angle)
        .task {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
                withAnimation(Animation.spring(response: 1, dampingFraction: 0.5, blendDuration: 0)) {
                    self.angle = Angle(degrees: Double.random(in: -20...20))
                }
            }
        }
    }
}

struct Compass_Previews: PreviewProvider {
    static var previews: some View {
        Compass()
    }
}
