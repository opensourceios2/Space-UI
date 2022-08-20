//
//  Font.swift
//  Space UI
//
//  Created by Jayden Irwin on 2020-11-03.
//  Copyright © 2020 Jayden Irwin. All rights reserved.
//

import SwiftUI

extension Font {
    
    enum Name: String {
        case abEquinox = "ABEquinoxBasic"
        case almostThere = "AlmostThere-Numeric"
        case auraboo = "Auraboo-Regular"
        case aurekBesh = "Aurek-Besh"
        case aurebeshBloops = "Aurebesh Bloops AF"
        case aurebeshDroid = "Aurebesh_droid-Regular"
        case aurebeshRacerFast = "AurebeshRacerAF-Fast"
        case baybayin = "Baybayin Rounded Regular"
        case fresian = "FresianAlphabetAF"
        case galactico = "Galactico"
        case mando = "MandoAF-Regular"
        case sFoil = "S-Foil"
        case sga2 = "SGA2"
        case theCalling = "TheCalling"
        case tradeFederation = "Trade Federation"
    }
    
    static func spaceFont(size: CGFloat) -> Font {
        guard let fontName = Space_UI.system.fontName else {
            return Font.system(size: size, weight: .bold)
        }
        let weight: Font.Weight = {
            switch fontName {
            case .baybayin:
                return .medium
            case .theCalling:
                return .regular
            case .aurebeshDroid, .sga2:
                return .bold
            default:
                return .heavy
            }
        }()
        return Font.custom(fontName.rawValue, fixedSize: size).weight(weight)
    }
    
}
