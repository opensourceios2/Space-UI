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
        case circularProgressView(progress: CGFloat), circularSegmentedView, decorativePolygon, spirograph, almostThereNumberText(number: Int)
    }
    
    @State var widget: Widget?
    @State var label: String
    @State var progress: CGFloat = 0.0
    
    var body: some View {
        switch widget {
        case .circularProgressView(let newProgress):
            CircularProgressView(value: self.$progress)
                .overlay(Text(label).multilineTextAlignment(.center))
                .onAppear() {
                    self.progress = newProgress
                }
        case .circularSegmentedView:
            CircularSegmentedView()
        case .decorativePolygon:
            DecorativePolygon(sides: 7)
                .stroke(Color(color: .primary, opacity: system.colors.paletteStyle == .monochrome ? .low : .medium), lineWidth: 2)
                .overlay(Text(label).multilineTextAlignment(.center))
        case .spirograph:
            Spirograph(innerRadius: 24, outerRadius: 43, distance: 34)
                .stroke(Color(color: .primary, opacity: system.colors.paletteStyle == .monochrome ? .low : .max), lineWidth: 2)
                .overlay(Text(label).multilineTextAlignment(.center))
        case .almostThereNumberText(let number):
            AlmostThereNumberText(number: number, digitCount: 4)
        default:
            EmptyView()
        }
    }
    
    init(random: GKRandom) {
        let widgetValue: Widget?
        switch random.nextInt(upperBound: 6) {
        case 0:
            widgetValue = .circularProgressView(progress: CGFloat(random.nextDouble(in: 0.1...1)))
        case 1:
            widgetValue = .circularSegmentedView
        case 2:
            widgetValue = .decorativePolygon
        case 3:
            widgetValue = .spirograph
        case 4:
            widgetValue = .almostThereNumberText(number: random.nextInt(upperBound: 9999))
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
