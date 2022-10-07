//
//  RandomWidget.swift
//  Space UI
//
//  Created by Jayden Irwin on 2020-12-04.
//  Copyright © 2020 Jayden Irwin. All rights reserved.
//

import SwiftUI

struct RandomWidget: View {
    
    enum Widget {
        case circularProgressView, circularSegmentedView, decorativePolygon, spirograph, almostThereNumberText
    }
    
    @State var widget: Widget?
    @State var label: String
    @StateObject private var progress = DoubleGenerator(averageFrequency: 8)
    @StateObject private var almostThereNumber = IntSequencer(frequency: TimeInterval.random(in: 0.1...5.0), initialValue: Int.random(in: 0...9999), maxValue: 9999)
    
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
    
    init(index: Int) {
        let widgetValue: Widget?
        switch (Int(system.seed) + index) % 6 {
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
        _label = State(initialValue: Lorem.word(index: index + 27))
    }
    
}

struct RandomWidget_Previews: PreviewProvider {
    static var previews: some View {
        RandomWidget(index: 0)
    }
}
