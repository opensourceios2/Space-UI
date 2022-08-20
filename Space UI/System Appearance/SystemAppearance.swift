//
//  Color.swift
//  Space UI
//
//  Created by Jayden Irwin on 2018-03-09.
//  Copyright © 2018 Jayden Irwin. All rights reserved.
//

import SwiftUI
import GameplayKit

var system = SystemAppearance(seed: {
    let savedSeed = UserDefaults.standard.integer(forKey: "seed")
    if savedSeed == 0 {
        let newSeed = UInt64(arc4random())
        UserDefaults.standard.set(Int(newSeed), forKey: UserDefaults.Key.seed)
        return newSeed
    } else {
        return UInt64(savedSeed)
    }
}())

enum SystemColor {
    case primary, secondary, tertiary, danger
}
enum Opacity {
    case min, low, medium, high, max
}
enum PaletteStyle {
    case colorful, monochrome, limited
}
enum BackgroundStyle {
    case color, gradientUp, gradientDown
}
enum ScreenFilter {
    case none, hLines, vLines
}
enum Alignment {
    case none, vertical, horizontal
}
enum ScreenShapeCase: String {
    case rectangle, capsule, circle, croppedCircle, hexagon, trapezoid, triangle
}
enum BasicShape {
    case circle, triangle, square, hexagon, trapezoid, diamond
}
enum ShapeDirection {
    case up, down
}
enum CornerStyle {
    case sharp, rounded, circular
}
enum CutoutStyle {
    case angle45, roundedAngle45, roundedRectangle, halfRounded, curved, none
}
enum CutoutEdge {
    case top, bottom, both, none
}
enum CutoutPosition {
    case leading, center, trailing
}
enum ArrowStyle {
    case triangle, droplet, pieSlice, map, concaveMap
}
enum ButtonSizingMode {
    case fixed, flexable
}

struct SafeCornerOffsets: Equatable {
    let topLeading: CGSize
    let topTrailing: CGSize
    let bottomLeading: CGSize
    let bottomTrailing: CGSize
}

final class SystemAppearance: ObservableObject {
    
    let random: GKRandomDistribution
    let seed: UInt64
    
    // Colors
    let paletteStyle: PaletteStyle
    var primaryHue: CGFloat
    var primarySaturation: CGFloat = 1.0
    var secondaryHue: CGFloat = 0.0
    var secondarySaturation: CGFloat = 0.0
    var tertiaryHue: CGFloat
    var tertiarySaturation: CGFloat = 1.0
    let dangerHue: CGFloat = 0.0
    let dangerSaturation: CGFloat = 1.0
    let primaryHueCopy: CGFloat
    let primarySaturationCopy: CGFloat = 1.0
    
    // General
    var screenMinBrightness: CGFloat
    var backgroundStyle: BackgroundStyle
    var screenFilter: ScreenFilter
    var alignment: Alignment
    var basicShape: BasicShape
    var shapeDirection: ShapeDirection
    var cornerStyle: CornerStyle
    var roundedCornerFraction: CGFloat
    var lineCap: CGLineCap
    var screenShapeCase: ScreenShapeCase
    var topMorseCodeSegments: [MorseCodeLine.Segment]?
    var bottomMorseCodeSegments: [MorseCodeLine.Segment]?
    var generalCutoutStyle: CutoutStyle
    private var cutoutEdge: CutoutEdge
    private var topCutoutPosition: CutoutPosition
    var bottomCutoutPosition: CutoutPosition
    lazy var safeCornerOffsets: SafeCornerOffsets = {
        #if os(tvOS)
        let maxCornerOffset: CGFloat = 128
        #else
        let maxCornerOffset: CGFloat = 40
        #endif
        let topCorners = min(cornerRadius(forLength: 600)/4, maxCornerOffset)
        let bottomCorners = min(cornerRadius(forLength: 600)/4, maxCornerOffset)
        let topCutoutCompensation = ((cutoutEdge == .top || cutoutEdge == .both) && UIScreen.main.bounds.width >= 500) ? -ScreenShape.cutoutHeight : 0.0
        let bottomCutoutCompensation = ((cutoutEdge == .bottom || cutoutEdge == .both) && UIScreen.main.bounds.width >= 500) ? -ScreenShape.cutoutHeight : 0.0
        let topLeading = CGSize(width: topCorners, height: topCorners + topCutoutCompensation)
        let topTrailing = CGSize(width: -topCorners, height: topCorners + topCutoutCompensation)
        let bottomLeading = CGSize(width: bottomCorners, height: -(bottomCorners + bottomCutoutCompensation))
        let bottomTrailing = CGSize(width: -bottomCorners, height: -(bottomCorners + bottomCutoutCompensation))
        return SafeCornerOffsets(topLeading: topLeading, topTrailing: topTrailing, bottomLeading: bottomLeading, bottomTrailing: bottomTrailing)
    }()
    var changeSquareButtonToRect: Bool
    var shapeButtonFrameWidth: CGFloat
    var shapeButtonFrameHeight: CGFloat
    var flexButtonFrameHeight: CGFloat = 54.0
    var preferedButtonSizingMode: ButtonSizingMode
    var circularSegmentedViewCurvedOuterEdge: Bool
    var prefersBorders: Bool
    var prefersButtonBorders: Bool
    var prefersDashedLines: Bool
    var prefersRandomLineDashing: Bool
    var borderInsetAmount: CGFloat
    
    // Fonts & Sounds
    private var defaultFontName: Font.Name
    var fontOverride = false
    var fontName: Font.Name? {
        return fontOverride ? nil : defaultFontName
    }
    #if os(tvOS)
    let defaultFontSize: CGFloat = 30.0
    #elseif targetEnvironment(macCatalyst)
    let defaultFontSize: CGFloat = 24.0
    #else
    let defaultFontSize: CGFloat = 20.0
    #endif
    var actionSoundResource: AudioController.Resource
    var buttonSoundResource: AudioController.Resource
    var alarmSoundResource: AudioController.Resource
    
    init(seed: UInt64) {
        self.seed = seed
        let source = GKMersenneTwisterRandomSource(seed: seed)
        random = GKRandomDistribution(randomSource: source, lowestValue: 0, highestValue: Int.max)
        srand48(Int(seed)) // Set seed for drand48?
        
        // Colors
        screenMinBrightness = CGFloat(random.nextDouble(in: 0...0.4))
        let allPaletteStyles: [WeightedElement<PaletteStyle>] = [
            .init(weight: 1, element: .monochrome),
            .init(weight: 1, element: .colorful),
            .init(weight: 4, element: .limited)
        ]
        paletteStyle = random.nextWeightedElement(in: allPaletteStyles)!
        primaryHue = CGFloat(random.nextFraction())
        primaryHueCopy = primaryHue
        if paletteStyle == .monochrome {
            primarySaturation = CGFloat(random.nextFraction())
            secondaryHue = primaryHue
            secondarySaturation = primarySaturation
            tertiaryHue = primaryHue
            tertiarySaturation = primarySaturation
        } else {
            if random.nextBool(chance: 0.2) {
                let secondaryHueOffset = 0.08 + CGFloat(random.nextDouble(in: 0...0.3))
                secondaryHue = primaryHue + secondaryHueOffset
                if 1 < secondaryHue {
                    secondaryHue -= 1
                }
                secondarySaturation = 0.5
            } // else white
            if paletteStyle == .limited {
                tertiaryHue = secondaryHue
                tertiarySaturation = secondarySaturation
            } else {
                let tertiaryHueOffset = 0.08 + CGFloat(random.nextDouble(in: 0...0.3))
                tertiaryHue = primaryHue + tertiaryHueOffset
                if 1 < tertiaryHue {
                    tertiaryHue -= 1
                }
            }
        }
        
        // General
        backgroundStyle = random.nextElement(in: [BackgroundStyle.gradientUp, .gradientDown, .color])!
        screenFilter = random.nextElement(in: [ScreenFilter.hLines, .vLines, .none])!
        let allScreenShapeCases: [WeightedElement<ScreenShapeCase>] = [
//            .init(weight: 0.1, element: .circle),
//            .init(weight: 0.1, element: .triangle),
            .init(weight: 1, element: .capsule),
            .init(weight: 1, element: .croppedCircle),
            .init(weight: 1, element: .hexagon),
            .init(weight: 1, element: .trapezoid),
            .init(weight: 1, element: .rectangle)
        ]
        screenShapeCase = random.nextWeightedElement(in: allScreenShapeCases)!
        
        alignment = random.nextElement(in: [Alignment.vertical, .horizontal, .none])!
        switch screenShapeCase {
        case .circle:
            basicShape = .circle
        case .triangle:
            basicShape = .triangle
        default:
            basicShape = random.nextElement(in: [BasicShape.circle, .triangle, .square, .hexagon, .trapezoid, .diamond])!
        }
        switch basicShape {
        case .hexagon, .triangle, .trapezoid:
            shapeDirection = (random.nextBool(chance: 0.333)) ? .down : .up
        default:
            shapeDirection = .up
        }
        let cornerStyle: CornerStyle
        if basicShape == .circle {
            cornerStyle = .circular
            generalCutoutStyle = random.nextElement(in: [CutoutStyle.roundedRectangle, .halfRounded, .curved])!
        } else {
            switch screenShapeCase {
            case .croppedCircle, .hexagon, .trapezoid, .rectangle:
                cornerStyle = random.nextBool(chance: 0.25) ? .sharp : .rounded
            case .capsule:
                cornerStyle = .circular
            default:
                cornerStyle = .rounded
            }
            if case .sharp = cornerStyle {
                generalCutoutStyle = .angle45
            } else {
                generalCutoutStyle = random.nextElement(in: [CutoutStyle.roundedRectangle, .halfRounded, .roundedAngle45, .curved])!
            }
        }
        
        func generateMorseCodeSegments() -> [MorseCodeLine.Segment] {
            let useColorShades = Bool.random()
            let shades: [Opacity] = [.low, .medium, .high, .max]
            var nodeLengths: [CGFloat] = [20, 20, 20, 40, 80, 120]
            if cornerStyle != .circular {
                nodeLengths.append(10)
            }
            let spaceLengths: [CGFloat] = [20, 40, 80, 120, 160, 200]
            
            var segs = [MorseCodeLine.Segment]()
            var sum: CGFloat = 0.0
            while sum < 1920.0 {
                let opacity = useColorShades ? shades.randomElement()! : Opacity.max
                let systemColor: SystemColor = {
                    switch Int.random(in: 0..<4) {
                    case 0:
                        return .secondary
                    case 1:
                        return .tertiary
                    default:
                        return .primary
                    }
                }()
                let nl = MorseCodeLine.Segment(length: nodeLengths.randomElement()!, systemColor: systemColor, opacity: opacity)
                let sl = MorseCodeLine.Segment(length: spaceLengths.randomElement()!, systemColor: nil, opacity: .min)
                segs.append(nl)
                segs.append(sl)
                sum += nl.length + sl.length
            }
            return segs
        }
        switch screenShapeCase {
        case .circle, .triangle:
            topMorseCodeSegments = nil
            bottomMorseCodeSegments = nil
        default:
            topMorseCodeSegments = random.nextBool(chance: 0.25) ? generateMorseCodeSegments() : nil
            bottomMorseCodeSegments = random.nextBool(chance: 0.25) ? generateMorseCodeSegments() : nil
        }
        
        roundedCornerFraction = 0.1 + CGFloat(random.nextDouble(in: 0...0.1))
        self.cornerStyle = cornerStyle
        if screenShapeCase == .circle || screenShapeCase == .triangle {
            cutoutEdge = .none
        } else {
            let allCutoutEdges: [WeightedElement<CutoutEdge>] = [
                .init(weight: 0.333, element: .none),
                .init(weight: 0.333, element: .both),
                .init(weight: 1, element: .top),
                .init(weight: 1, element: .bottom)
            ]
            cutoutEdge = random.nextWeightedElement(in: allCutoutEdges)!
        }
        let allCutoutPositions: [WeightedElement<CutoutPosition>] = [
            .init(weight: 1, element: .leading),
            .init(weight: 1, element: .trailing),
            .init(weight: 12, element: .center)
        ]
        topCutoutPosition = random.nextWeightedElement(in: allCutoutPositions)!
        bottomCutoutPosition = random.nextWeightedElement(in: allCutoutPositions)!
        switch cornerStyle {
        case .circular:
            lineCap = .round
        case .rounded:
            lineCap = random.nextBool() ? .round : .butt
        case .sharp:
            lineCap = .butt
        }
        let changeSquareButtonToRect = random.nextBool()
        self.changeSquareButtonToRect = changeSquareButtonToRect
        switch basicShape {
        case .circle:
            shapeButtonFrameWidth = 84
            shapeButtonFrameHeight = 84
        case .square:
            if changeSquareButtonToRect {
                shapeButtonFrameWidth = 90
                shapeButtonFrameHeight = 56
            } else {
                shapeButtonFrameWidth = 80
                shapeButtonFrameHeight = 80
            }
        case .trapezoid:
            shapeButtonFrameWidth = 90
            shapeButtonFrameHeight = 56
        case .triangle:
            shapeButtonFrameWidth = 104
            shapeButtonFrameHeight = 104
        case .diamond:
            shapeButtonFrameWidth = 100
            shapeButtonFrameHeight = 100
        case .hexagon:
            shapeButtonFrameWidth = 94
            shapeButtonFrameHeight = 94
        }
        preferedButtonSizingMode = random.nextBool(chance: 0.1) ? .flexable : .fixed
        switch basicShape {
        case .circle:
            circularSegmentedViewCurvedOuterEdge = true
        case .hexagon:
            circularSegmentedViewCurvedOuterEdge = false
        default:
            circularSegmentedViewCurvedOuterEdge = random.nextBool()
        }
        let prefersBorders = random.nextBool(chance: 0.666)
        self.prefersBorders = prefersBorders
        prefersButtonBorders = random.nextBool(chance: 0.333) ? false : prefersBorders
        let prefersDashedLines = random.nextBool(chance: 0.333)
        self.prefersDashedLines = prefersDashedLines
        borderInsetAmount = random.nextBool(chance: 0.1) ? CGFloat(random.nextInt(upperBound: 7))*2.0 : 0.0
        prefersRandomLineDashing = random.nextBool(chance: 0.2) ? prefersDashedLines : false
        
        let allFonts: [WeightedElement<Font.Name>] = [
            .init(weight: 1, element: .abEquinox),
            .init(weight: 1, element: .auraboo),
            .init(weight: 2, element: .aurebeshBloops),
            .init(weight: 2, element: .aurebeshDroid),
            .init(weight: 1, element: .aurebeshRacerFast),
            .init(weight: 1, element: .baybayin),
            .init(weight: 1, element: .fresian),
            .init(weight: 2, element: .galactico),
            .init(weight: 1, element: .mando),
            .init(weight: 1, element: .sga2),
            .init(weight: 1, element: .theCalling),
            .init(weight: 1, element: .tradeFederation),
            .init(weight: 4, element: .aurekBesh)
        ]
        defaultFontName = random.nextWeightedElement(in: allFonts)!
        actionSoundResource = random.nextBool() ? .action : .action2
        buttonSoundResource = random.nextElement(in: [AudioController.Resource.button, .button2, .button3])!
        alarmSoundResource = random.nextBool() ? .alarmLoop : .alarmHighLoop
        
        if let screenShapeOverrideString = UserDefaults.standard.string(forKey: UserDefaults.Key.screenShapeCaseOverride),
            let screenShapeOverride = ScreenShapeCase(rawValue: screenShapeOverrideString) {
            self.screenShapeCase = screenShapeOverride
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (_) in
            AudioController.shared.makeSoundsForSystem()
        }
    }
    
    func cornerRadius(forLength length: CGFloat, cornerStyle: CornerStyle = system.cornerStyle) -> CGFloat {
        switch cornerStyle {
        case .sharp:
            return 0.0
        case .circular:
            return length / 2.0
        case .rounded:
            return length * roundedCornerFraction
        }
    }
    
    func lineDash(lineWidth: CGFloat) -> [CGFloat] {
        var dash = [CGFloat]()
        if system.prefersDashedLines {
            let roundLineCapCompensation = system.lineCap == .round ? lineWidth : 0
            dash = Array.init(repeating: roundLineCapCompensation + CGFloat.random(in: 2...6), count: 25)
            if system.prefersRandomLineDashing {
                for index in 0..<dash.count {
                    dash[index] = roundLineCapCompensation + CGFloat.random(in: 8...256)
                }
            }
        }
        return dash
    }
    
    func edgesIgnoringSafeAreaForScreenShape() -> Edge.Set {
        #if targetEnvironment(macCatalyst)
        return .all
        #else
        if UIScreen.main.traitCollection.verticalSizeClass == .compact {
            return .vertical
        } else {
            switch screenShapeCase {
            case .hexagon, .croppedCircle, .capsule:
                if UIScreen.main.traitCollection.horizontalSizeClass == .compact {
                    return .bottom
                }
            case .rectangle:
                if case .sharp = system.cornerStyle {
                    return []
                }
            case .trapezoid:
                let screenTrapezoidHexagonCornerOffset = max(44, UIScreen.main.bounds.width/8)
                let cornerRadius = system.cornerRadius(forLength: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height))
                
                if case .sharp = system.cornerStyle {
                    if system.shapeDirection == .up {
                        return .top
                    } else {
                        return .bottom
                    }
                } else if (UIScreen.main.bounds.width - (screenTrapezoidHexagonCornerOffset + cornerRadius)*2) < 200 {
                    return .bottom
                }
            default:
                break
            }
            return .all
        }
        #endif
    }
    
    func cameraNotchObscuresScreenShape() -> Bool {
        return edgesIgnoringSafeAreaForScreenShape().contains(.top) && UIScreen.main.bounds.width < 500
    }
    
    func mainContentInsets(screenSize: CGSize) -> EdgeInsets {
        
        func mainContentHorizontalInset(screenSize: CGSize) -> CGFloat {
            switch screenShapeCase {
            case .capsule:
                return screenSize.height <= screenSize.width ? screenSize.height/4 : 0.0
            case .trapezoid:
                let screenTrapezoidHexagonCornerOffset = max(44, screenSize.width/8)
                return screenTrapezoidHexagonCornerOffset
            case .hexagon, .croppedCircle:
                let screenTrapezoidHexagonCornerOffset = max(44, screenSize.width/8)
                return screenSize.height <= screenSize.width ? screenTrapezoidHexagonCornerOffset : 0.0
            case .circle, .triangle:
                return screenSize.width/2 - min(screenSize.width, screenSize.height)*0.4
            default:
                return 0.0
            }
        }
        func mainContentVerticalInset(screenSize: CGSize) -> CGFloat {
            switch screenShapeCase {
            case .capsule:
                return screenSize.height <= screenSize.width ? 0.0 : screenSize.width/4
            case .hexagon, .croppedCircle:
                let screenTrapezoidHexagonCornerOffset = max(44, screenSize.width/8)
                return screenSize.height <= screenSize.width ? 0.0 : screenTrapezoidHexagonCornerOffset
            case .circle, .triangle:
                return screenSize.height/2 - min(screenSize.width, screenSize.height)*0.4
            default:
                return 0.0
            }
        }
        
        let allEdges = borderInsetAmount + 25
        let topOnly = topCutoutStyle(screenSize: screenSize, availableWidth: 999, insetAmount: 0) == .none ? 0.0 : ScreenShape.cutoutHeight
        let bottomOnly = bottomCutoutStyle(screenSize: screenSize, availableWidth: 999, insetAmount: 0) == .none ? 0.0 : ScreenShape.cutoutHeight
        var vertical = mainContentVerticalInset(screenSize: screenSize) + allEdges
        var horizontal = mainContentHorizontalInset(screenSize: screenSize) + allEdges
        
        #if targetEnvironment(macCatalyst)
        if screenShapeCase != .circle, screenShapeCase != .triangle {
            vertical += CGFloat.random(in: 25...100)
            horizontal += CGFloat.random(in: 50...200)
        }
        #endif
        
        let top = topOnly + vertical
        let bottom = bottomOnly + vertical
        return EdgeInsets(top: top, leading: horizontal, bottom: bottom, trailing: horizontal)
    }
    
    func topCutoutStyle(screenSize: CGSize, availableWidth: CGFloat, insetAmount: CGFloat) -> CutoutStyle {
        if availableWidth + insetAmount*2 < 210 {
            return .none
        } else if (screenShapeCase == .capsule || screenShapeCase == .croppedCircle || screenShapeCase == .hexagon) && screenSize.width < screenSize.height {
            return .none
        } else if cutoutEdge == .top || cutoutEdge == .both || cameraNotchObscuresScreenShape() {
            return generalCutoutStyle
        } else {
            return .none
        }
    }
    
    func bottomCutoutStyle(screenSize: CGSize, availableWidth: CGFloat, insetAmount: CGFloat) -> CutoutStyle {
        if availableWidth + insetAmount*2 < 210 {
            return .none
        } else if (screenShapeCase == .capsule || screenShapeCase == .croppedCircle || screenShapeCase == .hexagon) && screenSize.width < screenSize.height {
            return .none
        } else if cutoutEdge == .bottom || cutoutEdge == .both {
            return generalCutoutStyle
        } else {
            return .none
        }
    }
    
    func cutoutFrame(screenRect: CGRect, forTop: Bool) -> CGRect {
        let rect = screenRect
        let insetRect = screenRect
        let insetAmount: CGFloat = 0.0
        
        let cornerRadius: CGFloat = {
            let regularRadius = system.cornerRadius(forLength: min(rect.width, rect.height))
            if regularRadius.isZero {
                return 0.0
            } else if system.screenShapeCase == .capsule {
                return system.cornerRadius(forLength: min(insetRect.width, insetRect.height))
            } else if system.cornerStyle == .circular {
                return system.cornerRadius(forLength: min(rect.width, rect.height), cornerStyle: .rounded)
            } else {
                return max(40.0, (regularRadius - insetAmount) / 2.0)
            }
        }()
        let screenTrapezoidHexagonCornerOffset = max(44, rect.width/8)
        let replacableWidth: CGFloat = {
            if system.screenShapeCase == .croppedCircle {
                return insetRect.width - screenTrapezoidHexagonCornerOffset*2.0
            } else if system.screenShapeCase == .hexagon {
                let riseOverRun = (insetRect.height/2) / screenTrapezoidHexagonCornerOffset
                let angle = atan(riseOverRun)
                let offset = cornerRadius * abs(tan(angle / 2.0))
                return insetRect.width - (screenTrapezoidHexagonCornerOffset + offset)*2.0
            } else if system.screenShapeCase == .trapezoid {
                let topSideLength = insetRect.width - screenTrapezoidHexagonCornerOffset*2
                let topLeadingSpace = (insetRect.size.width - topSideLength)/2
                let riseOverRun = insetRect.size.height / topLeadingSpace
                let angle = atan(riseOverRun)
                let topOffset = cornerRadius * abs(tan(angle / 2.0))
                return insetRect.width - (screenTrapezoidHexagonCornerOffset + topOffset)*2.0
            } else {
                return insetRect.width - cornerRadius*2.0
            }
        }()
        let cutoutHeight: CGFloat = 50.0
        
        let totalTransitionWidth: CGFloat = {
            switch system.generalCutoutStyle {
            case .angle45:
                return cutoutHeight * 2.0
            case .roundedAngle45:
                let radius = cutoutHeight
                let betweenCenters = (1 + cos(.pi/4)) * radius
                return betweenCenters * 2.0
            case .halfRounded:
                return cutoutHeight * 2.0
            case .roundedRectangle:
                return cutoutHeight * 2.0
            case .curved:
                return cutoutHeight * 4.0
            case .none:
                return 0.0
            }
        }()
        let maxCutoutContentWidth = min(replacableWidth - totalTransitionWidth, 600.0)
        let preferedCutoutContentWidth = insetRect.width*0.35
        let cutoutContentWidth = min(preferedCutoutContentWidth, maxCutoutContentWidth)
        let totalLengthAroundCutout = (replacableWidth - cutoutContentWidth - totalTransitionWidth)
        var topLeadingLengthBeforeCutout = totalLengthAroundCutout/2
        var bottomLeadingLengthBeforeCutout = totalLengthAroundCutout/2
        
        if 200 < totalLengthAroundCutout {
            if system.getTopCutoutPosition() == .leading {
                topLeadingLengthBeforeCutout = totalLengthAroundCutout * 0.333333
            } else if system.getTopCutoutPosition() == .trailing {
                topLeadingLengthBeforeCutout = totalLengthAroundCutout * 0.666666
            }
            if system.bottomCutoutPosition == .leading {
                bottomLeadingLengthBeforeCutout = totalLengthAroundCutout * 0.333333
            } else if system.bottomCutoutPosition == .trailing {
                bottomLeadingLengthBeforeCutout = totalLengthAroundCutout * 0.666666
            }
        }
        
        if forTop {
            // x value is an offset from the center, not an actual origin.x
            return CGRect(x: topLeadingLengthBeforeCutout - totalLengthAroundCutout/2, y: rect.minY, width: cutoutContentWidth, height: cutoutHeight)
        } else {
            return CGRect(x: bottomLeadingLengthBeforeCutout - totalLengthAroundCutout/2, y: rect.maxY - cutoutHeight, width: cutoutContentWidth, height: cutoutHeight)
        }
    }
    
    func getTopCutoutPosition() -> CutoutPosition {
        return cameraNotchObscuresScreenShape() ? .center : topCutoutPosition
    }
    
    func reloadRootView() {
        objectWillChange.send()
    }
}
