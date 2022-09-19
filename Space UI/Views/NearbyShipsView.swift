//
//  NearbyShipsView.swift
//  Space UI
//
//  Created by Jayden Irwin on 2019-12-22.
//  Copyright © 2019 Jayden Irwin. All rights reserved.
//

import SwiftUI
import GameplayKit

struct NearbyShipsView: View {
    
    let random: GKRandom
    let hasRays: Bool
    let textRingPreferedRadius: CGFloat?
    let rotateTextRing: Bool
    let textRingPadding: CGFloat = 8.0
    let hasAsterisk: Bool
    let animatedRings: [Bool]
    let hasAxisLines: Bool
    let axisLineEndCount: Int
    let hasTrianglePointers: Bool
    let trianglePointerCount: Int
    let trianglePointerLength: CGFloat
    let fillTrianglePointers: Bool
    let hasRadarScan: Bool
    let showShipRotation: Bool
    
    @ObservedObject var nearbyShipsState = ShipData.shared.nearbyShipsState
    @State var textRingAngle = Angle.zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if self.hasRays {
                    DecorativeRaysView()
                }
                if let textRingPreferedRadius = self.textRingPreferedRadius {
                    CircularText(string: "Nearby ships detected. It is possible there are more ships that are cloaked.", radius: min(geometry.size.width/2, geometry.size.height/2, textRingPreferedRadius), onTopEdge: true)
                        .foregroundColor(Color(color: .primary, opacity: .medium))
                        .rotationEffect(self.textRingAngle)
                }
                if self.hasAsterisk {
                    AsteriskShape(lineEnds: 30)
                        .stroke(Color(color: .primary, opacity: .medium), lineWidth: 8)
                        .frame(width: 0.25 * min(geometry.size.width, geometry.size.height), height: 0.25 * min(geometry.size.width, geometry.size.height), alignment: .center)
                }
                ForEach(self.animatedRings.indices) { index in
                    DecorativeRingView(animateSize: self.animatedRings[index], minimumWidthFraction: decorativeRingMinimumWidthFraction(parentSize: geometry.size, ringIndex: index))
                        .frame(width: decorativeRingFrameLengths(parentSize: geometry.size, ringIndex: index))
                }
                if self.hasAxisLines {
                    AsteriskShape(lineEnds: self.axisLineEndCount)
                        .stroke(Color(color: .primary, opacity: .high), lineWidth: system.thinLineWidth)
                }
                if self.hasTrianglePointers {
                    CircularStack {
                        ForEach(0..<trianglePointerCount) { index in
                            if self.fillTrianglePointers {
                                Triangle(overrideDirection: .down)
                                    .foregroundColor(Color(color: .primary, opacity: .max))
                                    .frame(width: self.trianglePointerLength, height: self.trianglePointerLength, alignment: .center)
                                    .rotationEffect(CircularStack.subviewRotationAngles(stepCount: trianglePointerCount)[index])
                            } else {
                                Triangle(overrideDirection: .down)
                                    .stroke(Color(color: .primary, opacity: .max), lineWidth: system.thinLineWidth)
                                    .frame(width: self.trianglePointerLength, height: self.trianglePointerLength, alignment: .center)
                                    .rotationEffect(CircularStack.subviewRotationAngles(stepCount: trianglePointerCount)[index])
                            }
                        }
                    }
                    .frame(width: 200 + trianglePointerLength)
                }
                if self.hasRadarScan {
                    RadarScanView(random: self.random)
                        .blendMode(.lighten)
                }
                ShipData.shared.icon
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color(color: .secondary, opacity: .max))
                    .frame(width: 0.12 * min(geometry.size.width, geometry.size.height), height: 0.12 * min(geometry.size.width, geometry.size.height), alignment: .center)
                ForEach(self.nearbyShipsState.nearbyShips) { ship in
                    NearbyShipView(ship: ship, showShipRotation: self.showShipRotation)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: (ship.isLarge ? 0.2 : 0.1) * min(geometry.size.width, geometry.size.height), height: (ship.isLarge ? 0.2 : 0.1) * min(geometry.size.width, geometry.size.height), alignment: .center)
                        .offset(x: ship.coord.x * min(geometry.size.width, geometry.size.height), y: ship.coord.y * min(geometry.size.width, geometry.size.height))
                }
            }
            .drawingGroup()
            .position(x: geometry.size.width/2, y: geometry.size.height/2)
        }
        .onAppear() {
            AudioController.shared.play(.sonarLoop)
            if self.rotateTextRing {
                withAnimation(Animation.linear(duration: 30.0).repeatForever(autoreverses: false)) {
                    self.textRingAngle = Angle.degrees(360)
                }
            }
        }
        .onDisappear() {
            AudioController.shared.stopLoopingSound(.sonarLoop)
        }
    }
    
    init(random: GKRandom) {
        self.random = random
        hasRays = random.nextBool(chance: 0.125)
        textRingPreferedRadius = random.nextBool(chance: 0.25) ? CGFloat(Int.random(in: 2...5)) * 50.0 : nil
        rotateTextRing = (textRingPreferedRadius != nil) && random.nextBool()
        hasAsterisk = random.nextBool(chance: 0.166)
        
        let ringCount = random.nextInt(in: 3...5)
        var rings = [Bool]()
        for _ in 0..<ringCount {
            rings.append(random.nextBool())
        }
        animatedRings = rings
        
        hasAxisLines = random.nextBool(chance: 0.166)
        axisLineEndCount = random.nextInt(in: 1...3)
        hasTrianglePointers = random.nextBool(chance: 0.25)
        trianglePointerCount = random.nextInt(in: 1...6)
        trianglePointerLength = CGFloat(random.nextInt(in: 15...30))
        fillTrianglePointers = random.nextBool()
        hasRadarScan = random.nextBool()
        showShipRotation = random.nextBool()
    }
    
    // The following 2 functions stop decorative rings from covering up the text ring.
    func decorativeRingMinimumWidthFraction(parentSize: CGSize, ringIndex: Int) -> CGFloat {
        if let textRingPreferedRadius = self.textRingPreferedRadius {
            let decorativeRingInsideTextRing = ringIndex < self.animatedRings.count/2
            if !decorativeRingInsideTextRing { // Stops outer rings from getting too small
                let ringMaxRadius = min(parentSize.width, parentSize.height)/2
                let textRingRadius = min(textRingPreferedRadius, ringMaxRadius)
                return (textRingRadius + textRingPadding) / ringMaxRadius
            }
        }
        return 0.1
    }
    func decorativeRingFrameLengths(parentSize: CGSize, ringIndex: Int) -> CGFloat? {
        if let textRingPreferedRadius = self.textRingPreferedRadius {
            let decorativeRingInsideTextRing = ringIndex < self.animatedRings.count/2
            if decorativeRingInsideTextRing { // Stops inner rings from getting too big
                let ringMaxRadius = min(parentSize.width, parentSize.height)/2
                let textRingRadius = min(textRingPreferedRadius, ringMaxRadius)
                return (textRingRadius - system.defaultFontSize - textRingPadding) * 2
            }
        }
        return nil
    }
    
}

struct NearbyShipsView_Previews: PreviewProvider {
    static var previews: some View {
        NearbyShipsView(random: GKRandomDistribution())
    }
}
