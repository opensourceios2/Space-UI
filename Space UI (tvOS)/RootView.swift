//
//  RootView.swift
//  Space UI (tvOS)
//
//  Created by Jayden Irwin on 2019-12-27.
//  Copyright © 2019 Jayden Irwin. All rights reserved.
//

import SwiftUI

var visiblePage = Page.externalDisplay

enum Page {
    case externalDisplay, lockScreen, seed, powerManagement, targeting, coms, nearby, planet, galaxy, ticTacToe, shield, music
}

struct RootView: View {
    
    private enum DisplayOrientation: String {
        case `default`, left, right
        
        var angle: Angle {
            switch self {
            case .left:
                return .degrees(90)
            case .right:
                return .degrees(-90)
            default:
                return .zero
            }
        }
    }
    
    @AppStorage(UserDefaults.Key.displayOrientation) private var displayOrientationRawValue = "default"
    private var displayOrientation: DisplayOrientation {
        DisplayOrientation(rawValue: displayOrientationRawValue) ?? .default
    }
    
    @State var currentPage: Page
    @State var showSeedView = false
    @ObservedObject var systemAppearance: SystemAppearance
    
    var body: some View {
        ScreenView {
            ExternalDisplayView()
        }
        .sheet(isPresented: self.$showSeedView) {
            SeedPage()
        }
        .ignoresSafeArea()
        .frame(width: displayOrientation == .default ? 1920 : 1080, height: displayOrientation == .default ? 1080 : 1920)
        .rotationEffect(displayOrientation.angle)
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
        RootView(currentPage: .externalDisplay, systemAppearance: system)
    }
}
