//
//  OrbitsView.swift
//  Space UI
//
//  Created by Jayden Irwin on 2020-03-18.
//  Copyright © 2020 Jayden Irwin. All rights reserved.
//

import SwiftUI
import GameplayKit

struct OrbitsView: View {
    
    struct Orbit: Identifiable {
        let size: CGSize
        let currentAngle: CGFloat
        let id = UUID()
    }
    
    let random: GKRandom = {
        let source = GKMersenneTwisterRandomSource(seed: system.seed)
        return GKRandomDistribution(randomSource: source, lowestValue: 0, highestValue: Int.max)
    }()
    let orbits: [Orbit]
    
    @State var phase: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .stroke(Color(color: .secondary, opacity: .high), lineWidth: 1)
                    .frame(width: geometry.size.width * 2.5, height: 1)
                Rectangle()
                    .stroke(Color(color: .secondary, opacity: .high), lineWidth: 1)
                    .frame(width: 1, height: geometry.size.height)
                ForEach(self.orbits) { orbit in
                    HStack(spacing: -1) {
                        Rectangle()
                            .stroke(Color(color: .secondary, opacity: .high), style: StrokeStyle(lineWidth: 1, lineCap: system.lineCap, dash: system.lineDash(lineWidth: 1)))
                            .frame(width: 1, height: geometry.size.height)
                        Ellipse()
                            .stroke(Color(color: .primary, opacity: .medium), lineWidth: 4)
                            .frame(width: orbit.size.width * geometry.size.width, height: orbit.size.height * geometry.size.height)
                            .zIndex(1)
                            .overlay(
                                Ellipse()
                                    .stroke(Color(color: .primary, opacity: .max), style: StrokeStyle(lineWidth: 5, dash: [700, 500], dashPhase: self.phase))
                            )
                            .overlay(
                                OrbitPlanetView()
                                    .offset(x: orbit.size.width/2 * geometry.size.width * cos(orbit.currentAngle), y: orbit.size.height/2 * geometry.size.height * sin(orbit.currentAngle))
                            )
                        Rectangle()
                            .stroke(Color(color: .secondary, opacity: .high), style: StrokeStyle(lineWidth: 1, lineCap: system.lineCap, dash: system.lineDash(lineWidth: 1)))
                            .frame(width: 1, height: geometry.size.height)
                    }
                }
            }
            .offset(x: -0.35 * geometry.size.width, y: 0)
            .position(x: geometry.size.width/2, y: geometry.size.height/2)
        }
        .task {
            withAnimation(Animation.linear(duration: 30).repeatForever(autoreverses: false)) {
                self.phase = 1200
            }
        }
    }
    
    init() {
        orbits = [
            Orbit(size: CGSize(width: 0.08, height: 0.10), currentAngle: CGFloat(random.nextDouble(in: -.pi ... .pi))/3),
            Orbit(size: CGSize(width: 0.22, height: 0.22), currentAngle: CGFloat(random.nextDouble(in: -.pi ... .pi))/3),
            Orbit(size: CGSize(width: 0.44, height: 0.31), currentAngle: CGFloat(random.nextDouble(in: -.pi ... .pi))/3),
            Orbit(size: CGSize(width: 0.90, height: 0.48), currentAngle: CGFloat(random.nextDouble(in: -.pi ... .pi))/3),
            Orbit(size: CGSize(width: 1.70, height: 0.85), currentAngle: CGFloat(random.nextDouble(in: -.pi ... .pi))/3)
        ]
    }
    
}

struct OrbitPlanetView: View {
    var body: some View {
        Hexagon()
            .frame(width: 30, height: 30)
            .foregroundColor(Color(color: .secondary, opacity: .max))
            .shadow(radius: 4)
            .overlay(
                Text(Lorem.word(index: 1))
                    .fixedSize()
                    .rotationEffect(Angle(degrees: 90), anchor: .bottomLeading)
                    .offset(x: 6, y: 10)
            , alignment: .bottomLeading)
            .overlay(
                Text(Lorem.word(index: 2))
                    .foregroundColor(Color(color: .tertiary, opacity: .max))
                    .fixedSize()
                    .offset(x: 35, y: 0)
            , alignment: .topLeading)
    }
}

struct OrbitsView_Previews: PreviewProvider {
    static var previews: some View {
        OrbitsView()
    }
}
