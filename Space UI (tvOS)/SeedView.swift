//
//  SeedView.swift
//  Space UI (tvOS)
//
//  Created by Jayden Irwin on 2020-03-29.
//  Copyright © 2020 Jayden Irwin. All rights reserved.
//

import SwiftUI

extension ScreenShapeCase: Identifiable {
    var id: Self { self }
}

struct SeedView: View {
    
    let allScreenShapeCases: [ScreenShapeCase] = [
        .circle, // This is actually used to remove the override
        .rectangle, .hexagon, .trapezoid, .capsule
    ]
    
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
    @State var screenShapeCaseOverride: ScreenShapeCase? = ScreenShapeCase(rawValue: UserDefaults.standard.string(forKey: UserDefaults.Key.screenShapeCaseOverride) ?? "")
    
    @ObservedObject var peerSessionController = PeerSessionController.shared
    
    @Namespace var mainNamespace
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Seed", text: self.$seedCopy, onCommit: {
                        self.saveSeed()
                    })
                        .keyboardType(.numberPad)
                        .disabled(isLocked)
                    Button(action: {
                        AudioController.shared.play(.action)
                        self.seedCopy = String(arc4random())
                        self.saveSeed()
                    }, label: { Label("Randomize", systemImage: "arrow.2.circlepath") })
                        .disabled(isLocked)
                        .prefersDefaultFocus(in: mainNamespace)
                } header: {
                    Text("Seed")
                }
                Picker("Screen Shape", selection: Binding(get: {
                    screenShapeCaseOverride ?? .circle
                }, set: { newValue in
                    if newValue == .circle {
                        screenShapeCaseOverride = nil
                    } else {
                        screenShapeCaseOverride = newValue
                    }
                })) {
                    ForEach(allScreenShapeCases) { shapeCase in
                        Image(systemName: {
                            switch shapeCase {
                            case .rectangle:
                                return "rectangle.fill"
                            case .hexagon:
                                return "hexagon.fill"
                            case .trapezoid:
                                return "triangle.fill"
                            case .capsule:
                                return "capsule.fill"
                            default:
                                return "questionmark.circle"
                            }
                        }())
                            .tag(shapeCase)
                    }
                }
                Link(destination: URL(string: UIApplication.openSettingsURLString)!) {
                    Label("Open Settings", systemImage: "gear")
                }
                HStack {
                    Text("Sync Over Network")
                    Spacer()
                    Text(syncOverNetworkBody)
                        .foregroundColor(.secondary)
                }
            }
        }
        .font(.body)
        .foregroundColor(.primary)
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
