//
//  RootView.swift
//  Space UI (tvOS)
//
//  Created by Jayden Irwin on 2019-12-27.
//  Copyright © 2019 Jayden Irwin. All rights reserved.
//

import SwiftUI

var visibleInterface = Interface.externalDisplay

enum Interface {
    case externalDisplay, lockScreen, seed, powerManagement, targeting, coms, nearby, planet, galaxy, ticTacToe, shield, music
}

struct RootView: View {
    
    @State var interface: Interface
    @State var showSeedView = false
    @ObservedObject var systemAppearance: SystemAppearance
    
    var body: some View {
        ScreenView {
            ExternalDisplayView()
        }
        .sheet(isPresented: self.$showSeedView) {
            SeedView()
        }
        .ignoresSafeArea()
        .font(Font.spaceFont(size: system.defaultFontSize))
        .foregroundColor(Color(color: .secondary, opacity: .max))
        .environmentObject(system)
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("showSeedView"))) { _ in
            self.showSeedView = true
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(interface: .externalDisplay, systemAppearance: system)
    }
}
