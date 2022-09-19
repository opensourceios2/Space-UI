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
        
        var defaultFontSize: CGFloat {
            let fontFamilySize: CGFloat = {
                switch self {
                case .abEquinox:
                    return 20.0
                case .almostThere:
                    return 20.0
                case .auraboo:
                    return 20.0
                case .aurekBesh:
                    return 20.0
                case .aurebeshBloops:
                    return 19.0
                case .aurebeshDroid:
                    return 24.0
                case .aurebeshRacerFast:
                    return 24.0
                case .baybayin:
                    return 20.0
                case .fresian:
                    return 20.0
                case .galactico:
                    return 20.0
                case .mando:
                    return 28.0
                case .sFoil:
                    return 20.0
                case .sga2:
                    return 25.0
                case .theCalling:
                    return 24.0
                case .tradeFederation:
                    return 17.0
//                default:
//                    return 20.0
                }
            }()
            #if os(tvOS)
            return fontFamilySize * 1.5
            #elseif targetEnvironment(macCatalyst)
            return fontFamilySize * 1.2
            #else
            return fontFamilySize
            #endif
        }
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
