//
//  PowerManagementView.swift
//  Space UI
//
//  Created by Jayden Irwin on 2019-12-15.
//  Copyright © 2019 Jayden Irwin. All rights reserved.
//

import SwiftUI
import GameplayKit

struct PowerManagementView: View {
    
    let random: GKRandom = {
        let source = GKMersenneTwisterRandomSource(seed: system.seed)
        return GKRandomDistribution(randomSource: source, lowestValue: 0, highestValue: Int.max)
    }()
    let model: String = {
        let seedInt = Int(system.seed)
        let alphaNum = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let numberOfDigits = Int.numberOfDigits(for: seedInt, inBase: alphaNum.count)
        let digits = Int.representation(of: seedInt, inBase: alphaNum.count, withDigitCount: numberOfDigits)
        var alphaNumRepresentation = ""
        for digit in digits {
            let index = alphaNum.index(alphaNum.startIndex, offsetBy: digit)
            alphaNumRepresentation.append(alphaNum[index])
        }
        return alphaNumRepresentation
    }()
    
    var body: some View {
        GeometryReader { geometry in
            AutoStack {
                ZStack {
                    ShipData.shared.icon
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color(color: .secondary, opacity: .max))
                        .frame(width: min(geometry.size.width, 700), height: min(geometry.size.width, 700), alignment: .center)
                    VStack(spacing: 20) {
                        NavigationButton(to: .shield) {
                            Text("Shield")
                        }
                        NavigationButton(to: .coms) {
                            Text("Coms")
                        }
                        NavigationButton(to: .powerManagement) {
                            Text("Battery")
                        }
                        NavigationButton(to: .powerManagement) {
                            Text("Engine")
                        }
                    }
                }
                VStack {
                    Text("Model: \(self.model)")
                        .font(Font.spaceFont(size: 22))
                        .padding()
                    AutoGrid(spacing: 16) {
                        NavigationButton(to: .lockScreen) {
                            Text("Lock")
                        }
                        NavigationButton(to: .nearby) {
                            Text("Nearby")
                        }
                    }
                    .frame(idealWidth: system.shapeButtonFrameWidth, maxWidth: 2 * system.shapeButtonFrameWidth, idealHeight: system.shapeButtonFrameHeight, maxHeight: 2 * system.shapeButtonFrameHeight, alignment: .center)
                }
            }
            .position(x: geometry.size.width/2, y: geometry.size.height/2)
        }
        .overlay(alignment: .topLeading) {
            RandomWidget(random: random)
                .frame(width: 100, height: 100)
                .offset(system.safeCornerOffsets.topLeading)
        }
        .overlay(alignment: .topTrailing) {
            RandomWidget(random: random)
                .frame(width: 100, height: 100)
                .offset(system.safeCornerOffsets.topTrailing)
        }
    }
}

struct PowerManagementView_Previews: PreviewProvider {
    static var previews: some View {
        PowerManagementView()
    }
}