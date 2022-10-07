//
//  PlanetPage.swift
//  Space UI
//
//  Created by Jayden Irwin on 2019-12-15.
//  Copyright © 2019 Jayden Irwin. All rights reserved.
//

import SwiftUI

struct PlanetPage: View {
    
    @Environment(\.verticalSizeClass) private var vSizeClass
    @Environment(\.horizontalSizeClass) private var hSizeClass
    
    @StateObject private var progressPublisher1 = DoubleGenerator(averageFrequency: 8)
    @StateObject private var progressPublisher2 = DoubleGenerator(averageFrequency: 8)
    @StateObject private var progressPublisher3 = DoubleGenerator(averageFrequency: 8)
    @StateObject private var progressPublisher4 = DoubleGenerator(averageFrequency: 8)
    @StateObject private var progressPublisher5 = DoubleGenerator(averageFrequency: 8)
    @StateObject private var progressPublisher6 = DoubleGenerator(averageFrequency: 8)
    @StateObject private var progressPublisher7 = DoubleGenerator(averageFrequency: 8)
    @StateObject private var progressPublisher8 = DoubleGenerator(averageFrequency: 8)
    
    var body: some View {
        VStack {
            HStack {
                if hSizeClass == .regular {
                    VStack {
                        RandomWidget(index: 1)
                        AutoStack {
                            Text("\(Lorem.word(index: 1))\n\(Lorem.word(index: 2))\n\(Lorem.word(index: 3))\n\(Lorem.word(index: 4))")
                                .multilineTextAlignment(.leading)
                            Spacer()
                            VStack {
                                BinaryView(value: 62)
                                BinaryView(value: 25)
                            }
                        }
                    }
                }
                VStack {
                    ShipOnPlanetView()
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
                .layoutPriority(2)
                if hSizeClass == .regular {
                    VStack {
                        AutoStack {
                            Text("\(Lorem.word(index: 1))\n\(Lorem.word(index: 2))\n\(Lorem.word(index: 3))\n\(Lorem.word(index: 4))")
                                .multilineTextAlignment(.leading)
                            Spacer()
                            VStack {
                                BinaryView(value: 62)
                                BinaryView(value: 25)
                            }
                        }
                        RandomWidget(index: 2)
                    }
                    .multilineTextAlignment(.trailing)
                }
            }
            if vSizeClass == .regular {
                HStack(spacing: 16) {
                    ForEach(0..<4) { index in
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
                        .frame(minWidth: 56, idealWidth: system.circularProgressWidgetIdealLength, minHeight: 56, idealHeight: system.circularProgressWidgetIdealLength, maxHeight: 100)
                    }
                }
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
}

struct PlanetPage_Previews: PreviewProvider {
    static var previews: some View {
        PlanetPage()
    }
}
