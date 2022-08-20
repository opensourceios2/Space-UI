//
//  PlanetView.swift
//  Space UI
//
//  Created by Jayden Irwin on 2019-12-15.
//  Copyright © 2019 Jayden Irwin. All rights reserved.
//

import SwiftUI
import GameplayKit

struct PlanetView: View {
    
    let random: GKRandom = {
        let source = GKMersenneTwisterRandomSource(seed: system.seed)
        return GKRandomDistribution(randomSource: source, lowestValue: 0, highestValue: Int.max)
    }()
    let pointIconsAreCircles: Bool
    let pointsHaveLabels: Bool
    let points: [CGPoint]
    let planetAngle: Double
    
    @State var sphereAnimationProgress: CGFloat = 0.0
    
    @State var progress1: CGFloat = 0.0
    @State var progress2: CGFloat = 0.0
    @State var progress3: CGFloat = 0.0
    @State var progress4: CGFloat = 0.0
    @State var progress5: CGFloat = 0.0
    @State var progress6: CGFloat = 0.0
    @State var progress7: CGFloat = 0.0
    @State var progress8: CGFloat = 0.0
    
    var body: some View {
        AutoStack {
            GeometryReader { geometry in
                VStack {
                    if 300 < min(geometry.size.width, geometry.size.height) {
                        AutoStack {
                            Text("\(Lorem.word(random: self.random))\n\(Lorem.word(random: self.random))\n\(Lorem.word(random: self.random))\n\(Lorem.word(random: self.random))")
                                .multilineTextAlignment(.leading)
                                .animation(.none)
                            Spacer()
                            VStack {
                                BinaryView(value: self.random.nextInt(in: 0...31), maxValue: 31)
                                BinaryView(value: self.random.nextInt(in: 0...31), maxValue: 31)
                            }
                        }
                        Spacer()
                    }
                    AutoGrid(spacing: 16) {
                        ForEach(0..<(300 < min(geometry.size.width, geometry.size.height) ? 4 : 2)) { index in
                            ZStack {
                                CircularProgressView(value: {
                                    switch index {
                                    case 0:
                                        return self.$progress5
                                    case 1:
                                        return self.$progress6
                                    case 2:
                                        return self.$progress7
                                    default:
                                        return self.$progress8
                                    }
                                }())
                                Text(Lorem.word(random: self.random))
                                    .animation(.none)
                            }
                        }
                    }
                }
                .position(x: geometry.size.width/2, y: geometry.size.height/2)
            }
            AutoStack {
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        ZStack(alignment: .bottom) {
                            Ellipse()
                                .stroke(Color(color: .primary, opacity: .max), lineWidth: 4)
                                .frame(width: geometry.size.height/4, height: geometry.size.height/2, alignment: .center)
                            Ellipse()
                                .stroke(Color(color: .primary, opacity: .max), lineWidth: 4)
                                .frame(width: geometry.size.height/8, height: geometry.size.height/4, alignment: .center)
                            ShipData.shared.icon
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(Color(color: .secondary, opacity: .max))
                                .frame(height: geometry.size.height/8, alignment: .center)
                        }
                        ZStack(alignment: .leading) {
                            RadialGradient(gradient: Gradient(colors: [.clear, Color(color: .primary, opacity: .low)]), center: .center, startRadius: 0, endRadius: geometry.size.height/4)
                                .clipShape(Circle())
                            Sphere(vertical: self.planetLines(size: geometry.size), horizontal: self.planetLines(size: geometry.size))
                                .trim(from: 0.0, to: self.sphereAnimationProgress)
                                .stroke(Color(color: .primary, opacity: .max), lineWidth: 4)
                                .rotationEffect(Angle(degrees: self.planetAngle))
                            ForEach(self.points.indices) { i in
                                HStack {
                                    if self.pointIconsAreCircles {
                                        Image(CircleIcon.randomName(random: self.random))
                                            .foregroundColor(Color(color: .tertiary, opacity: .max))
                                            .shadow(color: Color(color: .primary, opacity: .min), radius: 8, x: 0, y: 0)
                                    } else {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: system.cornerRadius(forLength: 24))
                                                .fill(Color(color: .tertiary, opacity: .max))
                                                .frame(width: 24, height: 24)
                                            Image(GeneralIcon.randomName(random: self.random))
                                                .foregroundColor(Color(color: .tertiary, opacity: .min))
                                        }
                                    }
                                    if self.pointsHaveLabels {
                                        Text(Lorem.word(random: self.random))
                                            .frame(minWidth: 0, idealWidth: nil, maxWidth: 100)
                                            .fixedSize()
                                            .lineLimit(nil)
                                            .font(Font.spaceFont(size: 18))
                                            .foregroundColor(Color(color: .tertiary, opacity: .max))
                                            .animation(.none)
                                    }
                                }
                                .offset(x: CGFloat(self.points[i].x * min(geometry.size.width, geometry.size.height/2)), y: CGFloat(self.points[i].y * min(geometry.size.width, geometry.size.height/2)))
                            }
                        }
                            .frame(width: min(geometry.size.width, geometry.size.height/2), height: min(geometry.size.width, geometry.size.height/2), alignment: .center)
                    }
                    .frame(minHeight: geometry.size.height/2)
                    .position(x: geometry.size.width/2, y: geometry.size.height/2)
                }
                AutoGrid(spacing: 16) {
                    NavigationButton(to: .nearby) {
                        Text("Nearby")
                    }
                    NavigationButton(to: .targeting) {
                        Text("Targeting")
                    }
                    NavigationButton(to: .galaxy) {
                        Text("Galaxy")
                    }
                }
            }
            GeometryReader { geometry in
                VStack {
                    AutoStack {
                        VStack {
                            BinaryView(value: self.random.nextInt(in: 0...31), maxValue: 31)
                            BinaryView(value: self.random.nextInt(in: 0...31), maxValue: 31)
                        }
                        Spacer()
                        Text("\(Lorem.word(random: self.random))\n\(Lorem.word(random: self.random))\n\(Lorem.word(random: self.random))\n\(Lorem.word(random: self.random))")
                            .multilineTextAlignment(.trailing)
                            .animation(.none)
                    }
                    Spacer()
                    AutoGrid(spacing: 16) {
                        ForEach(0..<(300 < min(geometry.size.width, geometry.size.height) ? 4 : 2)) { index in
                            ZStack {
                                CircularProgressView(value: {
                                    switch index {
                                    case 0:
                                        return self.$progress5
                                    case 1:
                                        return self.$progress6
                                    case 2:
                                        return self.$progress7
                                    default:
                                        return self.$progress8
                                    }
                                }())
                                Text(Lorem.word(random: self.random))
                                    .animation(.none)
                            }
                        }
                    }
                }
                .position(x: geometry.size.width/2, y: geometry.size.height/2)
            }
        }
            .multilineTextAlignment(.center)
            .onAppear() {
                withAnimation(.linear(duration: 1.0)) {
                    self.sphereAnimationProgress = 1.0
                }
                self.progress1 = CGFloat(self.random.nextDouble(in: 0.1...1))
                self.progress2 = CGFloat(self.random.nextDouble(in: 0.1...1))
                self.progress3 = CGFloat(self.random.nextDouble(in: 0.1...1))
                self.progress4 = CGFloat(self.random.nextDouble(in: 0.1...1))
                self.progress5 = CGFloat(self.random.nextDouble(in: 0.1...1))
                self.progress6 = CGFloat(self.random.nextDouble(in: 0.1...1))
                self.progress7 = CGFloat(self.random.nextDouble(in: 0.1...1))
                self.progress8 = CGFloat(self.random.nextDouble(in: 0.1...1))
            }
    }
    
    init() {
        pointIconsAreCircles = random.nextBool()
        pointsHaveLabels = random.nextBool()
        points = PoissonDiskSampling.samples(in: CGRect(x: 0, y: -0.5, width: 1, height: 1), inCircle: true, staticPoint: nil, candidatePointCount: 4, rejectRadius: 0.2, random: random)
        planetAngle = random.nextDouble(in: 0..<360)
    }
    
    func planetLines(size: CGSize) -> Int {
        let availableLength = min(size.width, size.height)
        return Int(availableLength / 37.0)
    }
    
}

struct PlanetView_Previews: PreviewProvider {
    static var previews: some View {
        PlanetView()
    }
}
