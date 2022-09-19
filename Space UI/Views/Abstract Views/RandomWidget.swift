//
//  RandomWidget.swift
//  Space UI
//
//  Created by Jayden Irwin on 2020-12-04.
//  Copyright © 2020 Jayden Irwin. All rights reserved.
//

import SwiftUI
import GameplayKit

struct RandomWidget: View {
    
    enum Widget {
        case circularProgressView, circularSegmentedView, decorativePolygon, spirograph, almostThereNumberText
    }
    
    @State var widget: Widget?
    @State var label: String
    @StateObject private var progress = DoubleGenerator(averageFrequency: 8)
    @StateObject private var almostThereNumber = IntGenerator(range: 0...9999, averageFrequency: 8)
    
    var body: some View {
        switch widget {
        case .circularProgressView:
            CircularProgressView(value: self.$progress.value) {
                Text(label)
            }
        case .circularSegmentedView:
            CircularSegmentedView()
        case .decorativePolygon:
            DecorativePolygon(sides: 7)
                .stroke(Color(color: .primary, opacity: system.colors.paletteStyle == .monochrome ? .low : .medium), lineWidth: system.thinLineWidth)
                .overlay {
                    Text(label).multilineTextAlignment(.center).padding(16)
                }
        case .spirograph:
            Spirograph(innerRadius: 24, outerRadius: 43, distance: 34)
                .stroke(Color(color: .primary, opacity: system.colors.paletteStyle == .monochrome ? .low : .max), lineWidth: system.thinLineWidth)
                .overlay {
                    Text(label).multilineTextAlignment(.center).padding(16)
                }
        case .almostThereNumberText:
            AlmostThereNumberText(number: self.$almostThereNumber.value, digitCount: 4)
        default:
            EmptyView()
        }
    }
    
    init(random: GKRandom) {
        let widgetValue: Widget?
        switch random.nextInt(upperBound: 6) {
        case 0:
            widgetValue = .circularProgressView
        case 1:
            widgetValue = .circularSegmentedView
        case 2:
            widgetValue = .decorativePolygon
        case 3:
            widgetValue = .spirograph
        case 4:
            widgetValue = .almostThereNumberText
        default:
            widgetValue = nil
        }
        _widget = State(initialValue: widgetValue)
        _label = State(initialValue: Lorem.word(random: random))
    }
    
}

struct RandomWidget_Previews: PreviewProvider {
    static var previews: some View {
        RandomWidget(random: GKRandomDistribution())
    }
}
