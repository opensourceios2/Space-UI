//
//  Color.swift
//  Space UI
//
//  Created by Jayden Irwin on 2019-12-15.
//  Copyright © 2019 Jayden Irwin. All rights reserved.
//

import SwiftUI

extension Color {
    
    init(color: SystemColor, opacity: Opacity) {
        let hue: CGFloat
        let saturation: CGFloat
        switch color {
        case .primary:
            hue = system.primaryHue
            saturation = system.primarySaturation
        case .secondary:
            hue = system.secondaryHue
            saturation = system.secondarySaturation
        case .tertiary:
            hue = system.tertiaryHue
            saturation = system.tertiarySaturation
        case .danger:
            hue = system.dangerHue
            saturation = system.dangerSaturation
        }
        let opacityMultiplier: CGFloat = {
            switch opacity {
            case .min:
                return 0.0
            case .low:
                return 0.33
            case .medium:
                return 0.55
            case .high:
                return 0.77
            case .max:
                return 1.0
            }
        }()
        let actualOpacity = system.screenMinBrightness + (opacityMultiplier * (1.0 - system.screenMinBrightness))
        self.init(displayP3Hue: hue, saturation: saturation, brightness: 1.0, opacity: CGFloat(actualOpacity))
    }
    
    init(color: SystemColor, brightness: Opacity) {
        let hue: CGFloat
        let saturation: CGFloat
        switch color {
        case .primary:
            hue = system.primaryHue
            saturation = system.primarySaturation
        case .secondary:
            hue = system.secondaryHue
            saturation = system.secondarySaturation
        case .tertiary:
            hue = system.tertiaryHue
            saturation = system.tertiarySaturation
        case .danger:
            hue = system.dangerHue
            saturation = system.dangerSaturation
        }
        let brightnessMultiplier: CGFloat = {
            switch brightness {
            case .min:
                return 0.0
            case .low:
                return 0.33
            case .medium:
                return 0.55
            case .high:
                return 0.77
            case .max:
                return 1.0
            }
        }()
        let actualBrightness = system.screenMinBrightness + (brightnessMultiplier * (1.0 - system.screenMinBrightness))
        self.init(displayP3Hue: hue, saturation: saturation, brightness: CGFloat(actualBrightness), opacity: 1.0)
    }
    
    init(displayP3Hue hue: CGFloat, saturation: CGFloat, brightness: CGFloat, opacity: CGFloat) {
        let standardRGB = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: opacity)
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        standardRGB.getRed(&red, green: &green, blue: &blue, alpha: nil)
        self.init(.displayP3, red: Double(red), green: Double(green), blue: Double(blue), opacity: Double(opacity))
    }
    
}

extension UIColor {
    convenience init(displayP3Hue hue: CGFloat, saturation: CGFloat, brightness: CGFloat, opacity: CGFloat) {
        let standardRGB = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: opacity)
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        standardRGB.getRed(&red, green: &green, blue: &blue, alpha: nil)
        self.init(displayP3Red: red, green: green, blue: blue, alpha: opacity)
    }
}
