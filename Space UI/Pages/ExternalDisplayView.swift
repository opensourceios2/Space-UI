//
//  ExternalDisplayPage.swift
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

struct ExternalDisplayPage: View {
    
    let has2textLists = Bool.random()
    let hasLongNumericalSection = Bool.random()
    let useGridCompassStyle = Bool.random()
    
    @Environment(\.safeCornerOffsets) private var safeCornerOffsets
    
    @ObservedObject var music = MusicController.shared
    
    @StateObject private var progressPublisher1 = DoubleGenerator(averageFrequency: 8)
    @StateObject private var progressPublisher2 = DoubleGenerator(averageFrequency: 8)
    @StateObject private var progressPublisher3 = DoubleGenerator(averageFrequency: 8)
    @StateObject private var progressPublisher4 = DoubleGenerator(averageFrequency: 8)
    @StateObject private var progressPublisher5 = DoubleGenerator(averageFrequency: 8)
    @StateObject private var progressPublisher6 = DoubleGenerator(averageFrequency: 8)
    
    var body: some View {
        VStack {
            OrbitsView()
                .overlay(alignment: .topLeading) {
                    TextPair(label: "Realtime", value: "Orbits", largerFontSize: 50)
                        .offset(safeCornerOffsets.topLeading)
                }
                .overlay(alignment: .topTrailing) {
                    AutoCompass(useGridCompassStyle: self.useGridCompassStyle)
                        .frame(width: 150, height: 150)
                        .offset(safeCornerOffsets.topTrailing)
                }
            if system.screenShapeCase != .verticalHexagon {
                HStack {
                    if self.has2textLists {
                        ViewThatFits {
                            VStack(spacing: 10) {
                                RoundedRectangle(cornerRadius: system.cornerRadius(forLength: 40))
                                    .stroke(Color(color: .primary, opacity: .max), lineWidth: system.mediumLineWidth)
                                    .foregroundColor(Color.clear)
                                    .frame(height: 40)
                                    .frame(idealWidth: .infinity, maxWidth: .infinity)
                                    .overlay(Text(Lorem.words(index: 1, count: 2)))
                                ForEach(0..<8) { index in
                                    HStack {
                                        Text(Lorem.word(index: 30 + index))
                                        Spacer()
                                        Text(Lorem.word(index: 38 + index))
                                    }
                                    .lineLimit(1)
                                }
                            }
                            EmptyView()
                        }
                    }
                    VStack {
                        HStack(alignment: .top) {
                            VStack {
                                BinaryView(value: 53)
                                Text(Lorem.word(index: 4))
                            }
                            AutoGrid(spacing: 16, ignoreMaxSize: false) {
                                ForEach(0..<4) { index in
                                    CircleIcon.image(index: index)
                                }
                            }
                            VStack {
                                BinaryView(value: 13)
                                Text(Lorem.word(index: 99))
                            }
                            if self.hasLongNumericalSection {
                                ViewThatFits {
                                    HStack(alignment: .top) {
                                        AutoGrid(spacing: 16, ignoreMaxSize: false) {
                                            ForEach(0..<4) { index in
                                                CircleIcon.image(index: 4 + index)
                                            }
                                        }
                                        VStack {
                                            BinaryView(value: 32)
                                            Text(Lorem.word(index: 5))
                                        }
                                    }
                                    EmptyView()
                                }
                            }
                        }
                        HStack {
                            RandomWidget(index: 6)
                                .frame(width: 120, height: 100)
                            VStack {
                                BinaryView(value: 23)
                                Text(Lorem.word(index: 6))
                            }
                            RandomWidget(index: 7)
                                .frame(width: 120, height: 100)
                        }
                        HStack(spacing: 16) {
                            CircularProgressView(value: $progressPublisher1.value)
                                .overlay {
                                    Text(Lorem.word(index: 7))
                                        .padding(16)
                                }
                            CircularProgressView(value: $progressPublisher2.value)
                                .overlay {
                                    Text(Lorem.word(index: 8))
                                        .padding(16)
                                }
                            CircularProgressView(value: $progressPublisher3.value)
                                .overlay {
                                    Text(Lorem.word(index: 9))
                                        .padding(16)
                                }
                            CircularProgressView(value: $progressPublisher4.value)
                                .overlay {
                                    Text(Lorem.word(index: 10))
                                        .padding(16)
                                }
                            if hasLongNumericalSection {
                                CircularProgressView(value: $progressPublisher5.value)
                                    .overlay {
                                        Text(Lorem.word(index: 11))
                                            .padding(16)
                                    }
                                CircularProgressView(value: $progressPublisher6.value)
                                    .overlay {
                                        Text(Lorem.word(index: 12))
                                            .padding(16)
                                    }
                            }
                        }
                        .aspectRatio(hasLongNumericalSection ? 6 : 4, contentMode: .fit)
                    }
                    .multilineTextAlignment(.center)
                    VStack(spacing: 10) {
                        RoundedRectangle(cornerRadius: system.cornerRadius(forLength: 40))
                            .stroke(Color(color: .primary, opacity: .max), lineWidth: system.mediumLineWidth)
                            .foregroundColor(Color.clear)
                            .frame(height: 40)
                            .frame(idealWidth: .infinity, maxWidth: .infinity)
                            .overlay(Text(Lorem.words(index: 13, count: 2)))
                        ForEach(0..<8) { index in
                            HStack {
                                Text(Lorem.word(index: 14 + index))
                                Spacer()
                                Text(Lorem.word(index: 22 + index))
                            }
                            .lineLimit(1)
                        }
                    }
                }
                .frame(maxHeight: 500)
            }
        }
        .animation(.linear(duration: 8), value: progressPublisher1.value)
        .animation(.linear(duration: 8), value: progressPublisher2.value)
        .animation(.linear(duration: 8), value: progressPublisher3.value)
        .animation(.linear(duration: 8), value: progressPublisher4.value)
        .animation(.linear(duration: 8), value: progressPublisher5.value)
        .animation(.linear(duration: 8), value: progressPublisher6.value)
        #if os(tvOS)
        .fullScreenCover(isPresented: $music.isStarWarsMainTitleSoundtrack) {
            MainTitleScrollView()
        }
        #endif
    }
}

struct ExternalDisplayPage_Previews: PreviewProvider {
    static var previews: some View {
        ExternalDisplayPage()
    }
}
