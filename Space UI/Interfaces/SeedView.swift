//
//  SeedView.swift
//  Space UI
//
//  Created by Jayden Irwin on 2020-01-10.
//  Copyright © 2020 Jayden Irwin. All rights reserved.
//

import SwiftUI

struct SeedView: View {
    
    @Environment(\.safeCornerOffsets) private var safeCornerOffsets
    @Environment(\.shapeDirection) private var shapeDirection: ShapeDirection
    
    var isLocked: Bool {
        !peerSessionController.mcSession.connectedPeers.isEmpty && !PeerSessionController.shared.isHost
    }
    var syncOverNetworkBody: String {
        if peerSessionController.mcSession.connectedPeers.isEmpty {
            switch (peerSessionController.canHost, peerSessionController.canJoin) {
            case (true, true):
                return "Looking to host/join..."
            case (true, false):
                return "Looking to host..."
            case (false, true):
                return "Looking to join..."
            case (false, false):
                return "Disabled"
            }
        } else if peerSessionController.isHost {
            return "Hosting \(peerSessionController.mcSession.connectedPeers.count) Peers"
        } else {
            return "Connected To Peers"
        }
    }
    
    @State var seedCopy = String(system.seed)
    @State var screenShapeCaseOverride: ScreenShapeCase? = ScreenShapeCase(rawValue: UserDefaults.standard.string(forKey: UserDefaults.Key.screenShapeCaseOverride) ?? "") {
        didSet {
            saveScreenShape()
        }
    }
    @FocusState var seedIsFocused: Bool
    
    @ObservedObject var peerSessionController = PeerSessionController.shared
    
    var body: some View {
        VStack {
            Spacer()
            Text("Seed")
            AutoStack {
                TextField("Seed", text: self.$seedCopy, onCommit: {
                    saveSeed()
                })
                    .foregroundColor(isLocked ? Color(color: .primary, opacity: .high) : nil)
                    .padding()
                    .frame(width: 178, height: system.flexButtonFrameHeight)
                    .background(Color(color: .primary, opacity: isLocked ? .low : .medium))
                    .cornerRadius(system.cornerRadius(forLength: system.flexButtonFrameHeight))
                    .keyboardType(.numberPad)
                    .submitLabel(.done)
                    .disabled(isLocked)
                    .focused($seedIsFocused)
                HStack {
                    Button(action: {
                        AudioController.shared.play(.action)
                        self.seedCopy = String(arc4random())
                        self.saveSeed()
                    }, label: { Image(systemName: "arrow.2.circlepath") })
                        .buttonStyle(FlexButtonStyle(isDisabled: self.isLocked))
                        .disabled(isLocked)
                    #if !os(tvOS)
                    Button(action: {
                        AudioController.shared.play(.action)
                        UIPasteboard.general.string = self.seedCopy
                    }, label: { Image(systemName: "doc.on.doc") })
                        .buttonStyle(FlexButtonStyle())
                    #endif
                }
            }
                .frame(idealHeight: system.flexButtonFrameHeight, maxHeight: system.flexButtonFrameHeight, alignment: .center)
            Text("Screen Shape")
            HStack {
                Button(action: {
                    self.screenShapeCaseOverride = nil
                }, label: {
                    Image(systemName: "questionmark.circle")
                }).buttonStyle(GroupedButtonStyle(segmentPosition: .leading, width: system.flexButtonFrameHeight, isSelected: self.screenShapeCaseOverride == nil))
                Button(action: {
                    self.screenShapeCaseOverride = .rectangle
                }, label: {
                    Image(systemName: "rectangle.fill")
                }).buttonStyle(GroupedButtonStyle(segmentPosition: .middle, width: system.flexButtonFrameHeight, isSelected: self.screenShapeCaseOverride == .rectangle))
                Button(action: {
                    self.screenShapeCaseOverride = .verticalHexagon
                }, label: {
                    Image(systemName: "hexagon.fill")
                }).buttonStyle(GroupedButtonStyle(segmentPosition: .middle, width: system.flexButtonFrameHeight, isSelected: self.screenShapeCaseOverride == .verticalHexagon))
                Button(action: {
                    self.screenShapeCaseOverride = .horizontalHexagon
                }, label: {
                    Image(systemName: "hexagon.fill")
                }).buttonStyle(GroupedButtonStyle(segmentPosition: .middle, width: system.flexButtonFrameHeight, isSelected: self.screenShapeCaseOverride == .horizontalHexagon))
                Button(action: {
                    self.screenShapeCaseOverride = .trapezoid
                }, label: {
                    Image(systemName: "triangle.fill")
                }).buttonStyle(GroupedButtonStyle(segmentPosition: .middle, width: system.flexButtonFrameHeight, isSelected: self.screenShapeCaseOverride == .trapezoid))
                Button(action: {
                    self.screenShapeCaseOverride = .capsule
                }, label: {
                    Image(systemName: "capsule.fill")
                }).buttonStyle(GroupedButtonStyle(segmentPosition: .trailing, width: system.flexButtonFrameHeight, isSelected: self.screenShapeCaseOverride == .capsule))
            }
            Text("Sync Over Network")
            Text(syncOverNetworkBody)
                .foregroundColor(Color(color: .secondary, brightness: .medium))
            Spacer()
            if system.preferedButtonSizingMode == .fixed {
                Link(destination: URL(string: UIApplication.openSettingsURLString)!) {
                    Image(systemName: "gear")
                }
                .buttonStyle(ShapeButtonStyle(shapeDirection: shapeDirection))
            } else {
                Link(destination: URL(string: UIApplication.openSettingsURLString)!) {
                    Image(systemName: "gear")
                }
                .buttonStyle(FlexButtonStyle())
            }
            Spacer()
        }
        .onTapGesture {
            seedIsFocused = false
            saveSeed()
        }
        .overlay(alignment: .topTrailing) {
            NavigationButton(to: .lockScreen) {
                Image(systemName: "xmark")
            }
            .offset(safeCornerOffsets.topTrailing)
        }
        .font(Font.system(size: 18, weight: .semibold, design: .rounded))
    }
    
    func saveSeed() {
        guard let newSeed = UInt64(self.seedCopy), newSeed != system.seed else { return }
        
        if peerSessionController.isHost {
            peerSessionController.send(message: .seed(newSeed))
        }
        system = SystemAppearance(seed: newSeed)
        DispatchQueue.main.async {
            replaceRootView()
        }
    }
    
    func saveScreenShape() {
        if let shapeCase = self.screenShapeCaseOverride {
            system.screenShapeCase = shapeCase
            UserDefaults.standard.set(shapeCase.rawValue, forKey: UserDefaults.Key.screenShapeCaseOverride)
        } else {
            UserDefaults.standard.removeObject(forKey: UserDefaults.Key.screenShapeCaseOverride)
        }
    }
    
}

struct SeedView_Previews: PreviewProvider {
    static var previews: some View {
        SeedView()
    }
}
