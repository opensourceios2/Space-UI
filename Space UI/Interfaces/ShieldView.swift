//
//  ShieldView.swift
//  Space UI
//
//  Created by Jayden Irwin on 2019-12-15.
//  Copyright © 2019 Jayden Irwin. All rights reserved.
//

import SwiftUI
import GameplayKit

struct ShieldView: View {
    
    let random: GKRandom = {
        let source = GKMersenneTwisterRandomSource(seed: system.seed)
        return GKRandomDistribution(randomSource: source, lowestValue: 0, highestValue: Int.max)
    }()
    
    let word1: String
    let word2: String
    let word3: String
    let word4: String
    let word5: String
    
    @ObservedObject var shipData = ShipData.shared
    @State var atomAngle = 0.0
    @State var atomDistance: CGFloat = 30
    
    var body: some View {
        AutoStack {
            ZStack {
                Circle()
                    .strokeBorder(LinearGradient(gradient: Gradient(colors: [Color(color: .tertiary, opacity: .max), Color(color: .primary, opacity: .min)]), startPoint: .top, endPoint: .bottom), lineWidth: 8)
                    .rotationEffect(Angle(degrees: self.shipData.shieldAngle))
                ShipData.shared.icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color(color: .secondary, opacity: .max))
                    .scaleEffect(0.75)
            }
            .overlay(
                NavigationButton(to: .powerManagement) {
                    Text("Power")
                }
            , alignment: .top)
            .overlay(
                RandomWidget(random: random)
                    .frame(width: 100, height: 100, alignment: .center)
                    .offset(system.safeCornerOffsets.topLeading)
            , alignment: .topLeading)
            .overlay(
                Spirograph(innerRadius: 42, outerRadius: 22, distance: self.atomDistance)
                    .stroke(Color(color: .primary, opacity: .max), lineWidth: 2)
                    .frame(width: 150, height: 150, alignment: .center)
                    .rotationEffect(Angle(degrees: self.atomAngle))
                    .overlay(Text(word2).fixedSize())
                    .offset(system.safeCornerOffsets.topTrailing)
            , alignment: .topTrailing)
            .overlay(
                HStack {
                    Button(action: {
                        AudioController.shared.play(.action)
                        withAnimation {
                            self.shipData.shieldAngle -= 20.0
                        }
                    }, label: {
                        Image(systemName: "arrowtriangle.left.fill")
                    }).buttonStyle(GroupedButtonStyle(segmentPosition: .leading))
                    Button(action: {
                        AudioController.shared.play(.action)
                        withAnimation {
                            self.shipData.shieldAngle += 20.0
                        }
                    }, label: {
                        Image(systemName: "arrowtriangle.right.fill")
                    }).buttonStyle(GroupedButtonStyle(segmentPosition: .trailing))
                }
            , alignment: .bottom)
            VStack {
                Text(word3)
                Text(word4)
                Text(word5)
            }
                .frame(width: 350)
        }
        .onAppear() {
            withAnimation(Animation.linear(duration: 20.0).repeatForever(autoreverses: false)) {
                self.atomAngle = 360.0
            }
            withAnimation(Animation.easeInOut(duration: 8.0).repeatForever(autoreverses: true)) {
                self.atomDistance = 40
            }
        }
    }
    
    init() {
        word1 = Lorem.word(random: random)
        word2 = Lorem.word(random: random)
        word3 = Lorem.word(random: random)
        word4 = Lorem.word(random: random)
        word5 = Lorem.word(random: random)
    }
    
}

struct ShieldView_Previews: PreviewProvider {
    static var previews: some View {
        ShieldView()
    }
}
