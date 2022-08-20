//
//  ExternalDisplayView.swift
//  Space UI
//
//  Created by Jayden Irwin on 2019-12-15.
//  Copyright © 2019 Jayden Irwin. All rights reserved.
//

import SwiftUI
import GameplayKit

struct AutoCompass: View {
    
    let useGridCompassStyle: Bool
    
    var body: some View {
        Group {
            if self.useGridCompassStyle {
                GridCompass()
            } else {
                Compass()
            }
        }
    }
}

struct ExternalDisplayView: View {
    
    let random: GKRandom = {
        let source = GKMersenneTwisterRandomSource(seed: system.seed)
        return GKRandomDistribution(randomSource: source, lowestValue: 0, highestValue: Int.max)
    }()
    let has2textLists = Bool.random()
    let hasLongNumericalSection = Bool.random()
    let useGridCompassStyle = Bool.random()
    
    @ObservedObject var music = MusicController.shared
    
    @State var progress1: CGFloat = 0.0
    @State var progress2: CGFloat = 0.0
    @State var progress3: CGFloat = 0.0
    @State var progress4: CGFloat = 0.0
    @State var progress5: CGFloat = 0.0
    @State var progress6: CGFloat = 0.0
    
    var body: some View {
        VStack {
            OrbitsView()
                .overlay(
                    TextPair(label: "Realtime", value: "Orbits", largerFontSize: 50)
                        .offset(system.safeCornerOffsets.topLeading)
                , alignment: .topLeading)
                .overlay(
                    AutoCompass(useGridCompassStyle: self.useGridCompassStyle)
                        .frame(width: 150, height: 150)
                        .offset(system.safeCornerOffsets.topTrailing)
                , alignment: .topTrailing)
            HStack {
                if self.has2textLists {
                    VStack(spacing: 10) {
                        RoundedRectangle(cornerRadius: system.cornerRadius(forLength: 40))
                            .stroke(Color(color: .primary, opacity: .max), lineWidth: 4)
                            .foregroundColor(Color.clear)
                            .frame(height: 40)
                            .frame(idealWidth: .infinity, maxWidth: .infinity)
                            .overlay(Text(Lorem.words(2)))
                        ForEach(0..<8) { _ in
                            HStack {
                                Text(Lorem.word())
                                Spacer()
                                Text(Lorem.word())
                            }
                        }
                    }
                }
                VStack {
                    HStack(alignment: .top) {
                        VStack {
                            BinaryView(value: self.random.nextInt(in: 0...31), maxValue: 31)
                            Text(Lorem.word(random: self.random))
                        }
                        AutoGrid(spacing: 16) {
                            ForEach(0..<4) { _ in
                                Image(decorative: CircleIcon.randomName(random: self.random))
                            }
                        }
                        VStack {
                            BinaryView(value: self.random.nextInt(in: 0...31), maxValue: 31)
                            Text(Lorem.word(random: self.random))
                        }
                        if self.hasLongNumericalSection {
                            AutoGrid(spacing: 16) {
                                ForEach(0..<4) { _ in
                                    Image(decorative: CircleIcon.randomName(random: self.random))
                                }
                            }
                            VStack {
                                BinaryView(value: self.random.nextInt(in: 0...31), maxValue: 31)
                                Text(Lorem.word(random: self.random))
                            }
                        }
                    }
                    HStack {
                        RandomWidget(random: self.random)
                        VStack {
                            BinaryView(value: self.random.nextInt(in: 0...31), maxValue: 31)
                            Text(Lorem.word(random: self.random))
                        }
                        RandomWidget(random: self.random)
                    }
                    AutoGrid(spacing: 16) {
                        ZStack {
                            CircularProgressView(value: $progress1)
                            Text(Lorem.word(random: self.random))
                        }
                        ZStack {
                            CircularProgressView(value: $progress2)
                            Text(Lorem.word(random: self.random))
                        }
                        ZStack {
                            CircularProgressView(value: $progress3)
                            Text(Lorem.word(random: self.random))
                        }
                        ZStack {
                            CircularProgressView(value: $progress4)
                            Text(Lorem.word(random: self.random))
                        }
                        if hasLongNumericalSection {
                            ZStack {
                                CircularProgressView(value: $progress5)
                                Text(Lorem.word(random: self.random))
                            }
                            ZStack {
                                CircularProgressView(value: $progress6)
                                Text(Lorem.word(random: self.random))
                            }
                        }
                    }
                    .aspectRatio(hasLongNumericalSection ? 6 : 4, contentMode: .fit)
                }
                .multilineTextAlignment(.center)
                VStack(spacing: 10) {
                    RoundedRectangle(cornerRadius: system.cornerRadius(forLength: 40))
                        .stroke(Color(color: .primary, opacity: .max), lineWidth: 4)
                        .foregroundColor(Color.clear)
                        .frame(height: 40)
                        .frame(idealWidth: .infinity, maxWidth: .infinity)
                        .overlay(Text(Lorem.words(2)))
                    ForEach(0..<8) { _ in
                        HStack {
                            Text(Lorem.word())
                            Spacer()
                            Text(Lorem.word())
                        }
                    }
                }
            }
            .frame(maxHeight: 500)
        }
        .onAppear() {
            self.progress1 = CGFloat(self.random.nextDouble(in: 0.1...1))
            self.progress2 = CGFloat(self.random.nextDouble(in: 0.1...1))
            self.progress3 = CGFloat(self.random.nextDouble(in: 0.1...1))
            self.progress4 = CGFloat(self.random.nextDouble(in: 0.1...1))
            self.progress5 = CGFloat(self.random.nextDouble(in: 0.1...1))
            self.progress6 = CGFloat(self.random.nextDouble(in: 0.1...1))
        }
        #if os(tvOS)
        .fullScreenCover(isPresented: $music.isStarWarsMainTitleSoundtrack) {
            MainTitleScrollView()
        }
        #endif
    }
}

struct ExternalDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        ExternalDisplayView()
    }
}
