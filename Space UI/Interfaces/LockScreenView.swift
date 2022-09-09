//
//  ContentView.swift
//  Space UI
//
//  Created by Jayden Irwin on 2019-10-04.
//  Copyright © 2019 Jayden Irwin. All rights reserved.
//

import SwiftUI
import GameplayKit

struct LockScreenView: View {
    
    enum BrandNamePosition {
        case topCorner, centerRing
    }
    
    let random: GKRandom = {
        let source = GKMersenneTwisterRandomSource(seed: system.seed)
        return GKRandomDistribution(randomSource: source, lowestValue: 0, highestValue: Int.max)
    }()
    let hasRingViews: Bool
    let hasTopBottomRings: Bool
    let hasCircularSegmentedView: Bool
    let brandNamePosition: BrandNamePosition
    let shipName = "S-Wing"
    let shipManufacturer = "Space Corp."
    
    @Environment(\.safeCornerOffsets) private var safeCornerOffsets
    
    @State var topBottomRingsAngle = Angle.zero
    @State var notificationShadowColor = Color(color: .primary, opacity: .medium)
    @State var notificationOpacity = 1.0
    @State var tutorialIsShown = !UserDefaults.standard.bool(forKey: UserDefaults.Key.tutorialShown)
    
    var body: some View {
        ZStack {
            if hasRingViews {
                DecorativeRingView(animateSize: true, opacity: .low)
                DecorativeRingView(animateSize: true, opacity: .low)
            }
            if hasTopBottomRings {
                GeometryReader { geometry in
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, dash: [0.001, 28.0]))
                        .foregroundColor(Color(color: .primary, opacity: .medium))
                        .frame(height: geometry.size.width)
                        .rotationEffect(topBottomRingsAngle)
                        .position(x: geometry.size.width/2, y: -geometry.size.height * 0.4)
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, dash: [0.001, 28.0]))
                        .foregroundColor(Color(color: .primary, opacity: .medium))
                        .frame(height: geometry.size.width)
                        .rotationEffect(topBottomRingsAngle)
                        .position(x: geometry.size.width/2, y: geometry.size.height * 1.4)
                }
            }
            VStack {
                HStack {
                    if brandNamePosition == .topCorner {
                        TextPair(label: shipManufacturer, value: shipName, largerFontSize: 28)
                            .offset(safeCornerOffsets.topLeading)
                    }
                    Spacer()
                }
                Spacer()
                HStack {
                    ForEach(0..<self.random.nextInt(in: 3...5)) { _ in
                        Image(CircleIcon.randomName(random: self.random)).foregroundColor(Color(color: .primary, opacity: .high))
                    }
                }
            }
            AutoStack(spacing: 16) {
                NavigationButton(to: .powerManagement) {
                    Text("Ship")
                }
                NavigationButton(to: .ticTacToe) {
                    Text("Computer")
                }
            }
            .background(
                brandNamePosition == .topCorner ? nil :
                ZStack {
                    CircularText(string: shipName, radius: 150, onTopEdge: true)
                        .foregroundColor(Color(color: .primary, opacity: .max))
                    CircularText(string: shipManufacturer, radius: 150, onTopEdge: false)
                        .foregroundColor(Color(color: .primary, opacity: .medium))
                }
            )
        }
        .overlay( hasCircularSegmentedView ?
            RandomWidget(random: random)
                .frame(width: 100, height: 100)
                .offset(safeCornerOffsets.bottomLeading)
            : nil
        , alignment: .bottomLeading)
        .overlay(
            HStack {
                ForEach(0..<self.random.nextInt(in: 0...2)) { _ in
                    Image(LargeIcon.randomName(random: self.random))
                        .foregroundColor(Color(color: .primary, opacity: .max))
                        .shadow(color: self.notificationShadowColor, radius: 10, x: 0, y: 0)
                        .opacity(self.notificationOpacity)
                }
            }
            .offset(safeCornerOffsets.bottomTrailing)
        , alignment: .bottomTrailing)
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 0.75).repeatForever(autoreverses: true)) {
                self.notificationShadowColor = .clear
                self.notificationOpacity = 0.5
            }
            withAnimation(Animation.linear(duration: 100.0).repeatForever(autoreverses: false)) {
                self.topBottomRingsAngle = Angle.degrees(360)
            }
        }
        .sheet(isPresented: self.$tutorialIsShown, content: {
            TutorialView()
        })
    }
    
    init() {
        hasRingViews = random.nextBool(chance: 0.666)
        hasTopBottomRings = random.nextBool()
        hasCircularSegmentedView = random.nextBool()
        brandNamePosition = random.nextBool() ? .topCorner : .centerRing
    }
}

struct LockScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenView()
    }
}
