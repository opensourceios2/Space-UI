//
//  MusicView.swift
//  Space UI
//
//  Created by Jayden Irwin on 2019-12-15.
//  Copyright © 2019 Jayden Irwin. All rights reserved.
//

import SwiftUI
import AVKit
import GameplayKit

struct MusicView: View {
    
    @Environment(\.shapeDirection) var shapeDirection: ShapeDirection
    
    let showAlbumArtwork: Bool
    
    @ObservedObject var music = MusicController.shared
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                AutoGrid(spacing: 16) {
                    NavigationButton(to: .lockScreen) {
                        Text("Lock")
                    }
                    NavigationButton(to: .ticTacToe) {
                        Text("Game")
                    }
                }
                .frame(idealWidth: system.shapeButtonFrameWidth, maxWidth: 2 * system.shapeButtonFrameWidth, idealHeight: system.shapeButtonFrameHeight, maxHeight: 2 * system.shapeButtonFrameHeight, alignment: .center)
                if UserDefaults.standard.bool(forKey: UserDefaults.Key.showAlbumArtwork) && showAlbumArtwork && music.artwork != nil {
                    Image(uiImage: music.artwork!)
                        .colorMultiply(Color(color: .primary, opacity: .max))
                        .clipShape(AutoShape(direction: shapeDirection))
                }
            }
            Spacer()
            GeometryReader { geometry in
                AudioVisualizer(width: geometry.size.width)
                    .position(x: geometry.size.width/2, y: geometry.size.height/2)
            }
            Spacer()
            HStack {
                Button(action: {
                    AudioController.shared.play(.action)
                    self.music.skipToPrevious()
                }, label: {
                    Image(systemName: "circle.lefthalf.fill")
                }).buttonStyle(GroupedButtonStyle(segmentPosition: .leading))
                Button(action: {
                    AudioController.shared.play(.action)
                    self.music.playPause()
                }, label: {
                    Image(systemName: "circle")
                }).buttonStyle(GroupedButtonStyle(segmentPosition: .middle, isSelected: self.music.isPlaying))
                Button(action: {
                    AudioController.shared.play(.action)
                    self.music.skipToNext()
                }, label: {
                    Image(systemName: "circle.righthalf.fill")
                }).buttonStyle(GroupedButtonStyle(segmentPosition: .trailing))
            }
            HStack {
                CircularProgressView(value: $music.volume)
                    .frame(maxWidth: 80, maxHeight: 80)
                    .padding()
                Button(action: {
                    AudioController.shared.play(.action)
                    self.music.toggleRepeat()
                }, label: {
                    Text("Repeat")
                }).buttonStyle(ShapeButtonStyle(shapeDirection: shapeDirection, isSelected: !(self.music.systemPlayer.repeatMode == .none)))
            }
        }
    }
    
    init() {
        let random: GKRandom = {
            let source = GKMersenneTwisterRandomSource(seed: system.seed)
            return GKRandomDistribution(randomSource: source, lowestValue: 0, highestValue: Int.max)
        }()
        showAlbumArtwork = random.nextBool()
    }
}

struct MusicView_Previews: PreviewProvider {
    static var previews: some View {
        MusicView()
    }
}
