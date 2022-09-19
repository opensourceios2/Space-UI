//
//  NearbyView.swift
//  Space UI
//
//  Created by Jayden Irwin on 2019-12-15.
//  Copyright © 2019 Jayden Irwin. All rights reserved.
//

import SwiftUI
import GameplayKit

struct NearbyView: View {
    
    let random: GKRandom = {
        let source = GKMersenneTwisterRandomSource(seed: system.seed)
        return GKRandomDistribution(randomSource: source, lowestValue: 0, highestValue: Int.max)
    }()
    
    @Environment(\.safeCornerOffsets) private var safeCornerOffsets
    
    var body: some View {
        AutoStack {
            NearbyShipsView(random: random)
            AutoGrid(spacing: 16) {
                NavigationButton(to: .powerManagement) {
                    Text("Power")
                }
                NavigationButton(to: .coms) {
                    Text("Coms")
                }
                NavigationButton(to: .targeting) {
                    Text("Targeting")
                }
                NavigationButton(to: .planet) {
                    Text("Planet")
                }
            }
        }
        .overlay(alignment: .topLeading) {
            RandomWidget(random: random)
                .frame(maxWidth: 100, maxHeight: 100, alignment: .topLeading)
                .offset(safeCornerOffsets.topLeading)
        }
        .overlay(alignment: .topTrailing) {
            RandomWidget(random: random)
                .frame(maxWidth: 100, maxHeight: 100, alignment: .topTrailing)
                .offset(safeCornerOffsets.topTrailing)
        }
    }
}

struct NearbyView_Previews: PreviewProvider {
    static var previews: some View {
        NearbyView()
    }
}
