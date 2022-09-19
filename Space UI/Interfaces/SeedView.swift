//
//  SeedView.swift
//  Space UI
//
//  Created by Jayden Irwin on 2020-01-10.
//  Copyright © 2020 Jayden Irwin. All rights reserved.
//

import SwiftUI

struct SeedView: View {
    
    @AppStorage(UserDefaults.Key.externalDisplayOnTop) private var externalDisplayOnTop = false
    @AppStorage(UserDefaults.Key.externalDisplayOnBottom) private var externalDisplayOnBottom = false
    @AppStorage(UserDefaults.Key.externalDisplayOnLeft) private var externalDisplayOnLeft = false
    @AppStorage(UserDefaults.Key.externalDisplayOnRight) private var externalDisplayOnRight = false
    
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
            
            Group {
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
                
                #if DEBUG
                Text("Design Principles")
                LabeledContent("Simplicity", value: String(system.design.simplicity))
                LabeledContent("Sharpness", value: String(system.design.sharpness))
                LabeledContent("Order", value: String(system.design.order))
                LabeledContent("Balance", value: String(system.design.balance))
                LabeledContent("Boldness", value: String(system.design.boldness))
                #endif
                
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
                            .rotationEffect(.degrees(90))
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
            }
            
            Group {
                Text("External Screen Positions")
                Grid {
                    GridRow {
                        Spacer()
                            .gridCellUnsizedAxes([.horizontal, .vertical])
                        Button {
                            externalDisplayOnTop.toggle()
                        } label: {
                            Image(systemName: "tv")
                                .opacity(externalDisplayOnTop ? 1 : 0.5)
                        }
                        .buttonStyle(FlexButtonStyle(isSelected: externalDisplayOnTop))
                    }
                    GridRow {
                        Button {
                            externalDisplayOnLeft.toggle()
                        } label: {
                            Image(systemName: "tv")
                                .opacity(externalDisplayOnLeft ? 1 : 0.5)
                        }
                        .buttonStyle(FlexButtonStyle(isSelected: externalDisplayOnLeft))
                        Image(systemName: "tv")
                        Button {
                            externalDisplayOnRight.toggle()
                        } label: {
                            Image(systemName: "tv")
                                .opacity(externalDisplayOnRight ? 1 : 0.5)
                        }
                        .buttonStyle(FlexButtonStyle(isSelected: externalDisplayOnRight))
                    }
                    GridRow {
                        Spacer()
                            .gridCellUnsizedAxes([.horizontal, .vertical])
                        Button {
                            externalDisplayOnBottom.toggle()
                        } label: {
                            Image(systemName: "tv")
                                .opacity(externalDisplayOnBottom ? 1 : 0.5)
                        }
                        .buttonStyle(FlexButtonStyle(isSelected: externalDisplayOnBottom))
                    }
                }
                
                Text("Sync Over Network")
                Text(syncOverNetworkBody)
                    .foregroundColor(Color(color: .secondary, brightness: .medium))
            }
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
