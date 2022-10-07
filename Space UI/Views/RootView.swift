//
//  RootView.swift
//  Space UI
//
//  Created by Jayden Irwin on 2019-12-15.
//  Copyright © 2019 Jayden Irwin. All rights reserved.
//

import SwiftUI

enum Page {
    case externalDisplay, lockScreen, seed, powerManagement, targeting, coms, nearby, planet, galaxy, ticTacToe, shield, squad, music, sudokuPuzzle, lightsOutPuzzle, unlabeledKeypadPuzzle
}

struct RootView: View {
    
    let isExternal: Bool
    
    @Environment(\.verticalSizeClass) private var vSizeClass
    
    @State var currentPage: Page
    @State var showingDebugControls = true
    @ObservedObject var systemAppearance: SystemAppearance
    
    var body: some View {
        VStack {
            if vSizeClass == .regular, let segs = system.topMorseCodeSegments {
                MorseCodeLine(segments: segs)
                    .padding(.horizontal, 20)
            }
            ScreenView {
                switch currentPage {
                case .externalDisplay:
                    ExternalDisplayPage()
                case .lockScreen:
                    LockScreenPage()
                case .seed:
                    SeedPage()
                case .powerManagement:
                    PowerManagementPage()
                case .targeting:
                    TargetingPage()
                case .coms:
                    ComsPage()
                case .nearby:
                    NearbyPage()
                case .planet:
                    PlanetPage()
                case .galaxy:
                    GalaxyPage()
                case .ticTacToe:
                    TicTacToePage()
                case .shield:
                    ShieldPage()
                case .squad:
                    SquadPage()
                case .music:
                    MusicPage()
                case .sudokuPuzzle:
                    SudokuPage()
                case .lightsOutPuzzle:
                    LightsOutPage()
                case .unlabeledKeypadPuzzle:
                    UnlabeledKeypadPage()
                }
            }
            if vSizeClass == .regular, let segs = system.bottomMorseCodeSegments {
                MorseCodeLine(segments: segs)
                    .padding(.horizontal, 20)
            }
        }
        .ignoresSafeArea(edges: system.edgesIgnoringSafeAreaForScreenShape(screenSize: UIScreen.main.bounds.size, traitCollection: UIScreen.main.traitCollection))
        
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
            visiblePage = .seed
            NotificationCenter.default.post(name: NSNotification.Name("navigate"), object: nil)
        })
        #endif
        .environmentObject(system)
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("navigate"))) { _ in
            if !self.isExternal {
                self.currentPage = visiblePage
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(isExternal: false, currentPage: .lockScreen, systemAppearance: system)
    }
}
