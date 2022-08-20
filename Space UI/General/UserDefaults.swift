//
//  UserDefaults.swift
//  Space UI
//
//  Created by Jayden Irwin on 2020-02-17.
//  Copyright © 2020 Jayden Irwin. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    struct Key {
        static let appVersion = "appVersion"
        static let playAmbience = "playAmbience"
        static let playSounds = "playSounds"
        static let keepAwake = "keepAwake"
        static let showAlbumArtwork = "showAlbumArtwork"
        static let randomEmergencies = "randomEmergencies"
        static let seed = "seed"
        static let screenShapeCaseOverride = "screenShapeCaseOverride"
        static let tutorialShown = "tutorialShown"
        static let canHostSession = "canHostSession"
        static let canJoinSession = "canJoinSession"
    }
    
    func register() {
        register(defaults: [
            Key.playAmbience: true,
            Key.playSounds: true,
            Key.keepAwake: false,
            Key.showAlbumArtwork: true,
            Key.randomEmergencies: true,
            Key.tutorialShown: false,
            Key.canHostSession: true,
            Key.canJoinSession: true
        ])
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        setValue(version, forKey: Key.appVersion)
    }
    
}
