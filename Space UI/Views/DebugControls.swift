//
//  DebugControls.swift
//  Space UI
//
//  Created by Jayden Irwin on 2020-04-27.
//  Copyright © 2020 Jayden Irwin. All rights reserved.
//

#if DEBUG
import SwiftUI

struct DebugControls: View {
    var body: some View {
        VStack {
            Button(action: {
                system.fontOverride.toggle()
                DispatchQueue.main.async {
                    replaceRootView()
                }
            }, label: {
                Image(systemName: "textformat")
            })
                .buttonStyle(FlexButtonStyle())
            Button(action: {
                if ShipData.shared.isInEmergency {
                    ShipData.shared.endEmergency()
                } else {
                    ShipData.shared.beginEmergency()
                }
            }, label: {
                Image(systemName: "exclamationmark.triangle")
            })
                .buttonStyle(FlexButtonStyle())
            Button(action: {
                system = SystemAppearance(seed: UInt64(arc4random()))
                DispatchQueue.main.async {
                    if debugShowingExternalDisplay {
                        visibleInterface = savedInterface
                    } else {
                        savedInterface = visibleInterface
                        visibleInterface = .externalDisplay
                    }
                    replaceRootView()
                    debugShowingExternalDisplay.toggle()
                }
            }, label: {
                #if targetEnvironment(macCatalyst)
                Image(systemName: debugShowingExternalDisplay ? "tv" : "desktopcomputer")
                #else
                Image(systemName: debugShowingExternalDisplay ? "tv" : "iphone")
                #endif
            })
                .buttonStyle(FlexButtonStyle())
            Button(action: {
                system = SystemAppearance(seed: UInt64(arc4random()))
                DispatchQueue.main.async {
                    replaceRootView()
                }
            }, label: {
                Image(systemName: "arrow.2.circlepath")
            })
                .buttonStyle(FlexButtonStyle())
        }
    }
}

struct DebugControls_Previews: PreviewProvider {
    static var previews: some View {
        DebugControls()
    }
}
#endif
