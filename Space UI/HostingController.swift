//
//  HostingController.swift
//  Space UI
//
//  Created by Jayden Irwin on 2019-12-15.
//  Copyright © 2019 Jayden Irwin. All rights reserved.
//

import SwiftUI

final class HostingController: UIHostingController<RootView> {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.backgroundColor = .black
        overrideUserInterfaceStyle = .dark
    }
    
    #if os(iOS)
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    #endif
    
}
