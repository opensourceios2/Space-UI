//
//  PlanetDetailsView.swift
//  Space UI
//
//  Created by Jayden Irwin on 2020-03-16.
//  Copyright © 2020 Jayden Irwin. All rights reserved.
//

import SwiftUI

struct PlanetDetailsView: View {
    
    let showPlanetImage: Bool
    let monochromeLabels = Bool.random()
    
    @Binding var details: [String]
    @Binding var progress1: Double
    @Binding var progress2: Double
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                TextPair(prefersMonochrome: self.monochromeLabels, label: "Name", value: self.details[0])
                TextPair(prefersMonochrome: self.monochromeLabels, label: "Races", value: self.details[1])
                TextPair(prefersMonochrome: self.monochromeLabels, label: "Leadership", value: self.details[2])
                TextPair(prefersMonochrome: self.monochromeLabels, label: "Population", value: self.details[3])
                TextPair(prefersMonochrome: self.monochromeLabels, label: "Currency", value: self.details[4])
                HStack(alignment: .top) {
                    DecorativeBoxesView()
                    CircularProgressView(value: self.$progress1, lineWidth: nil)
                        .frame(width: 56, height: 56)
                    DecorativeBoxesView()
                    CircularProgressView(value: self.$progress2, lineWidth: nil)
                        .frame(width: 56, height: 56)
                }
            }
            Spacer()
        }
            .padding()
            .frame(maxWidth: 320)
            .background( self.showPlanetImage ?
                Image(["Mercury", "Planet3", "Venus"].randomElement()!)
                    .colorMultiply(Color(color: .primary, opacity: .max))
                    .rotationEffect(Angle(degrees: Double.random(in: 0..<360)))
                    .offset(x: 100, y: 100)
                    .opacity(0.5)
                : nil
            , alignment: .bottomTrailing)
            .background(Color(color: .primary, brightness: .low))
            .overlay(
                RoundedRectangle(cornerRadius: system.cornerStyle == .sharp ? 0 : 24)
                    .strokeBorder(Color(color: .primary, opacity: .max), style: StrokeStyle(lineWidth: system.mediumLineWidth, lineCap: system.lineCap, dash: system.lineDash(lineWidth: system.mediumLineWidth)))
            )
            .clipShape(RoundedRectangle(cornerRadius: system.cornerStyle == .sharp ? 0 : 24))
            .onAppear() {
                self.progress1 = Double.random(in: 0.1...1)
                self.progress2 = Double.random(in: 0.1...1)
            }
    }
    
}

struct PlanetDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PlanetDetailsView(showPlanetImage: true, details: .constant(["a", "b", "c", "d", "e"]), progress1: .constant(0.5), progress2: .constant(0.5))
    }
}
