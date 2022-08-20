//
//  RootView.swift
//  Space UI
//
//  Created by Jayden Irwin on 2019-12-15.
//  Copyright © 2019 Jayden Irwin. All rights reserved.
//

import SwiftUI

enum Interface {
    case externalDisplay, lockScreen, seed, powerManagement, targeting, coms, nearby, planet, galaxy, ticTacToe, shield, squad, music, sudokuPuzzle, lightsOutPuzzle, unlabeledKeypadPuzzle
}

struct RootView: View {
    
    let isExternal: Bool
    
    @State var interface: Interface
    @State var showingDebugControls = true
    @ObservedObject var systemAppearance: SystemAppearance
    
    var body: some View {
        VStack {
            if let segs = system.topMorseCodeSegments {
                MorseCodeLine(segments: segs)
                    .padding(.horizontal, 20)
            }
            ScreenView {
                switch interface {
                case .externalDisplay:
                    ExternalDisplayView()
                case .lockScreen:
                    LockScreenView()
                case .seed:
                    SeedView()
                case .powerManagement:
                    PowerManagementView()
                case .targeting:
                    TargetingView()
                case .coms:
                    ComsView()
                case .nearby:
                    NearbyView()
                case .planet:
                    PlanetView()
                case .galaxy:
                    GalaxyView()
                case .ticTacToe:
                    TicTacToeView()
                case .shield:
                    ShieldView()
                case .squad:
                    SquadView()
                case .music:
                    MusicView()
                case .sudokuPuzzle:
                    SudokuView()
                case .lightsOutPuzzle:
                    LightsOutView()
                case .unlabeledKeypadPuzzle:
                    UnlabeledKeypadView()
                }
            }
            if let segs = system.bottomMorseCodeSegments {
                MorseCodeLine(segments: segs)
                    .padding(.horizontal, 20)
            }
        }
        .ignoresSafeArea(edges: system.edgesIgnoringSafeAreaForScreenShape())
        
        #if DEBUG
        .overlay(alignment: .leading) {
            if !isExternal, showingDebugControls {
                DebugControls()
                    .padding()
                    .transition(.move(edge: .leading))
                    .onAppear() {
                        Timer.scheduledTimer(withTimeInterval: 60.0, repeats: false) { (_) in // Animation with delay will prevent taps
                            withAnimation {
                                self.showingDebugControls = false
                            }
                        }
                    }
            }
        }
        #if !targetEnvironment(macCatalyst)
        .gesture(
            DragGesture()
                .onEnded({ gesture in
                    if gesture.startLocation.x < 10 {
                        withAnimation {
                            self.showingDebugControls = true
                        }
                    } else if gesture.translation.width < 0, abs(gesture.translation.width) > abs(gesture.translation.height) {
                        withAnimation {
                            self.showingDebugControls = false
                        }
                    }
                })
        )
        #endif
        #endif
            
        .statusBar(hidden: true)
        .persistentSystemOverlays(.hidden)
        .font(Font.spaceFont(size: system.defaultFontSize))
        ._lineHeightMultiple(1.1)
        .foregroundColor(Color(color: .secondary, opacity: .max))
        #if targetEnvironment(macCatalyst)
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("showHideDebugMenu"))) { _ in
            self.showingDebugControls.toggle()
        }
        #else
        .onTapGesture(count: 2, perform: {
            visibleInterface = .seed
            NotificationCenter.default.post(name: NSNotification.Name("navigate"), object: nil)
        })
        #endif
        .environmentObject(system)
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("navigate"))) { _ in
            if !self.isExternal {
                self.interface = visibleInterface
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(isExternal: false, interface: .lockScreen, systemAppearance: system)
    }
}
