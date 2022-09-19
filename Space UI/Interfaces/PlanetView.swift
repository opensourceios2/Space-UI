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
    
    @Environment(\.verticalSizeClass) private var vSizeClass
    @Environment(\.horizontalSizeClass) private var hSizeClass
    
    @State var sphereAnimationProgress: CGFloat = 0.0
    
    @StateObject private var progressPublisher1 = DoubleGenerator(averageFrequency: 8)
    @StateObject private var progressPublisher2 = DoubleGenerator(averageFrequency: 8)
    @StateObject private var progressPublisher3 = DoubleGenerator(averageFrequency: 8)
    @StateObject private var progressPublisher4 = DoubleGenerator(averageFrequency: 8)
    @StateObject private var progressPublisher5 = DoubleGenerator(averageFrequency: 8)
    @StateObject private var progressPublisher6 = DoubleGenerator(averageFrequency: 8)
    @StateObject private var progressPublisher7 = DoubleGenerator(averageFrequency: 8)
    @StateObject private var progressPublisher8 = DoubleGenerator(averageFrequency: 8)
    
    var body: some View {
        AutoStack {
            if vSizeClass == .regular && hSizeClass == .regular {
                GeometryReader { geometry in
                    VStack {
                        ViewThatFits {
                            VStack {
                                AutoStack {
                                    Text("\(Lorem.word(index: 1))\n\(Lorem.word(index: 2))\n\(Lorem.word(index: 3))\n\(Lorem.word(index: 4))")
                                        .multilineTextAlignment(.leading)
                                        .animation(.none)
                                    Spacer()
                                    VStack {
                                        BinaryView(value: 62)
                                        BinaryView(value: 25)
                                    }
                                }
                                Spacer()
                            }
                            EmptyView()
                        }
                        AutoGrid(spacing: 16) {
                            ForEach(0..<(300 < min(geometry.size.width, geometry.size.height) ? 4 : 2)) { index in
                                CircularProgressView(value: {
                                    switch index {
                                    case 0:
                                        return self.$progressPublisher1.value
                                    case 1:
                                        return self.$progressPublisher2.value
                                    case 2:
                                        return self.$progressPublisher3.value
                                    default:
                                        return self.$progressPublisher4.value
                                    }
                                }()) {
                                    Text(Lorem.word(index: 5 + index))
                                }
                                .frame(minWidth: 56, idealWidth: system.circularProgressWidgetIdealLength, minHeight: 56, idealHeight: system.circularProgressWidgetIdealLength)
                            }
                        }
                    }
                    .position(x: geometry.size.width/2, y: geometry.size.height/2)
                }
            }
            VStack {
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        ZStack(alignment: .bottom) {
                            Ellipse()
                                .stroke(Color(color: .primary, opacity: .max), lineWidth: system.mediumLineWidth)
                                .frame(width: geometry.size.height/4, height: geometry.size.height/2, alignment: .center)
                            Ellipse()
                                .stroke(Color(color: .primary, opacity: .max), lineWidth: system.mediumLineWidth)
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
                                .stroke(Color(color: .primary, opacity: .max), lineWidth: system.mediumLineWidth)
                                .rotationEffect(Angle(degrees: self.planetAngle))
                            ForEach(self.points.indices) { i in
                                HStack {
                                    if self.pointIconsAreCircles {
                                        CircleIcon.image(index: 8)
                                            .foregroundColor(Color(color: .tertiary, opacity: .max))
                                            .shadow(color: Color(color: .primary, opacity: .min), radius: 8, x: 0, y: 0)
                                    } else {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: system.cornerRadius(forLength: 24))
                                                .fill(Color(color: .tertiary, opacity: .max))
                                                .frame(width: 24, height: 24)
                                            GeneralIcon.image(index: 9)
                                                .foregroundColor(Color(color: .tertiary, opacity: .min))
                                        }
                                    }
                                    if self.pointsHaveLabels {
                                        Text(Lorem.word(index: 8))
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
                HStack(spacing: system.basicShapeHStackSpacing) {
                    NavigationButton(to: .nearby) {
                        Text("Nearby")
                    }
                    NavigationButton(to: .targeting) {
                        Text("Targeting")
                    }
                    .environment(\.shapeDirection, .down)
                    NavigationButton(to: .galaxy) {
                        Text("Galaxy")
                    }
                }
            }
            .padding(.vertical, system.screenShapeCase == .verticalHexagon ? -100 : 0)
            GeometryReader { geometry in
                VStack {
                    AutoStack {
                        VStack {
                            BinaryView(value: 18)
                            BinaryView(value: 4)
                        }
                        Spacer()
                        Text("\(Lorem.word(index: 9))\n\(Lorem.word(index: 10))\n\(Lorem.word(index: 11))\n\(Lorem.word(index: 12))")
                            .multilineTextAlignment(.trailing)
                            .animation(.none)
                    }
                    Spacer()
                    AutoGrid(spacing: 16) {
                        ForEach(0..<(300 < min(geometry.size.width, geometry.size.height) ? 4 : 2)) { index in
                            CircularProgressView(value: {
                                switch index {
                                case 0:
                                    return self.$progressPublisher5.value
                                case 1:
                                    return self.$progressPublisher6.value
                                case 2:
                                    return self.$progressPublisher7.value
                                default:
                                    return self.$progressPublisher8.value
                                }
                            }()) {
                                Text(Lorem.word(index: 13 + index))
                            }
                            .frame(minWidth: 56, idealWidth: system.circularProgressWidgetIdealLength, minHeight: 56, idealHeight: system.circularProgressWidgetIdealLength)
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
        }
        .animation(.linear(duration: 8), value: progressPublisher1.value)
        .animation(.linear(duration: 8), value: progressPublisher2.value)
        .animation(.linear(duration: 8), value: progressPublisher3.value)
        .animation(.linear(duration: 8), value: progressPublisher4.value)
        .animation(.linear(duration: 8), value: progressPublisher5.value)
        .animation(.linear(duration: 8), value: progressPublisher6.value)
        .animation(.linear(duration: 8), value: progressPublisher7.value)
        .animation(.linear(duration: 8), value: progressPublisher8.value)
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
