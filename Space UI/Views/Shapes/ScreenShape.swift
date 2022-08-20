//
//  ScreenShape.swift
//  Space UI
//
//  Created by Jayden Irwin on 2019-12-19.
//  Copyright © 2019 Jayden Irwin. All rights reserved.
//

import SwiftUI

struct ScreenShape: InsettableShape {
    
    static let cutoutHeight: CGFloat = 50.0
    
    var insetAmount: CGFloat = 0.0
    
    func cutoutPoints(style: CutoutStyle, length: CGFloat, cutoutHeight: CGFloat) -> [CGPoint] {
        
        let totalTransitionLength: CGFloat = {
            switch style {
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
        let straightLength = length - totalTransitionLength
        var points = [CGPoint]()
        var point = CGPoint.zero
        
        switch style {
        case .angle45:
            point.x += cutoutHeight
            point.y += cutoutHeight
            points.append(point)
            point.x += straightLength
            points.append(point)
            point.x += cutoutHeight
            point.y -= cutoutHeight
            points.append(point)
        case .roundedAngle45:
            let radius = cutoutHeight
            let betweenCenters = (1 + cos(.pi/4)) * radius
            point.y += radius
            points.append(point)
            point.x += betweenCenters
            point.y -= radius
            points.append(point)
            point.y += radius
            point.x += straightLength
            points.append(point)
            point.y -= radius
            points.append(point)
            point.x += betweenCenters
            point.y += radius
            points.append(point)
        case .halfRounded:
            let radius = cutoutHeight
            point.x += radius
            points.append(point)
            point.y += radius
            point.x += straightLength
            points.append(point)
            point.y -= radius
            points.append(point)
        case .roundedRectangle:
            let radius = cutoutHeight / 2.0
            point.y += radius
            points.append(point)
            point.x += radius * 2.0
            points.append(point)
            point.y += radius
            point.x += straightLength
            points.append(point)
            point.y -= radius
            points.append(point)
            point.x += radius * 2.0
            points.append(point)
        case .curved:
            var start = point
            point.y += cutoutHeight
            point.x += cutoutHeight
            var control = point
            point.x += cutoutHeight
            points.append(point)
            points.append(control)
            point.x += straightLength
            start.x += straightLength + 4*cutoutHeight
            control.x += straightLength + 2*cutoutHeight
            points.append(point)
            points.append(start)
            points.append(control)
        case .none:
            point.x += straightLength
            points.append(point)
        }
        return points
    }
    
    // MARK: - Top Cutout
    
    func addTopCutout(path: inout Path, point: inout CGPoint, screenSize: CGSize, replacableWidth: CGFloat, topTrailingLengthAfterCutout: CGFloat, cutoutContentWidth: CGFloat, totalTransitionWidth: CGFloat, cutoutHeight: CGFloat, topLeadingLengthBeforeCutout: CGFloat) {
        point = path.currentPoint!
        point.x -= topTrailingLengthAfterCutout
        path.addLine(to: point)
        
        let topCutoutStyle = system.topCutoutStyle(screenSize: screenSize, availableWidth: replacableWidth, insetAmount: insetAmount)
        let topCutoutPoints = cutoutPoints(style: topCutoutStyle, length: cutoutContentWidth + totalTransitionWidth, cutoutHeight: cutoutHeight).map({
            CGPoint(x: point.x - $0.x, y: point.y + $0.y)
        })
        switch topCutoutStyle {
        case .angle45:
            path.addLine(to: topCutoutPoints[0])
            path.addLine(to: topCutoutPoints[1])
            path.addLine(to: topCutoutPoints[2])
        case .roundedAngle45:
            let radius = cutoutHeight
            path.addRelativeArc(center: topCutoutPoints[0], radius: radius, startAngle: Angle(degrees: -90), delta: Angle(radians: -Double.pi/4))
            path.addRelativeArc(center: topCutoutPoints[1], radius: radius, startAngle: Angle(radians: .pi*5/4 - .pi), delta: Angle(radians: Double.pi/4))
            path.addLine(to: topCutoutPoints[2])
            path.addRelativeArc(center: topCutoutPoints[3], radius: radius, startAngle: Angle(radians: .pi*3/2 - .pi), delta: Angle(radians: Double.pi/4))
            path.addRelativeArc(center: topCutoutPoints[4], radius: radius, startAngle: Angle(radians: .pi*3/4 - .pi), delta: Angle(radians: -Double.pi/4))
        case .halfRounded:
            let radius = cutoutHeight
            path.addRelativeArc(center: topCutoutPoints[0], radius: radius, startAngle: Angle(radians: -.pi*2), delta: Angle(radians: Double.pi/2.0))
            path.addLine(to: topCutoutPoints[1])
            path.addRelativeArc(center: topCutoutPoints[2], radius: radius, startAngle: Angle(radians: -.pi*3/2), delta: Angle(radians: Double.pi/2.0))
        case .roundedRectangle:
            let radius = cutoutHeight / 2.0
            path.addRelativeArc(center: topCutoutPoints[0], radius: radius, startAngle: Angle(radians: -.pi/2), delta: Angle(radians: -Double.pi/2.0))
            path.addRelativeArc(center: topCutoutPoints[1], radius: radius, startAngle: Angle(radians: 0), delta: Angle(radians: Double.pi/2.0))
            path.addLine(to: topCutoutPoints[2])
            path.addRelativeArc(center: topCutoutPoints[3], radius: radius, startAngle: Angle(radians: .pi*3/2 - .pi), delta: Angle(radians: Double.pi/2.0))
            path.addRelativeArc(center: topCutoutPoints[4], radius: radius, startAngle: Angle(radians: 0), delta: Angle(radians: -Double.pi/2.0))
        case .curved:
            path.addQuadCurve(to: topCutoutPoints[0], control: topCutoutPoints[1])
            path.addLine(to: topCutoutPoints[2])
            path.addQuadCurve(to: topCutoutPoints[3], control: topCutoutPoints[4])
        case .none:
            path.addLine(to: topCutoutPoints[0])
        }
        point.x -= cutoutContentWidth + totalTransitionWidth

        point = path.currentPoint!
        point.x -= topLeadingLengthBeforeCutout
        path.addLine(to: point)
    }
    
    // MARK: - Path
    
    func path(in rect: CGRect) -> Path {
        let insetRect = rect.insetBy(dx: insetAmount, dy: insetAmount)
        
        switch system.screenShapeCase {
        case .circle:
            return Circle().path(in: insetRect)
        case .triangle:
            return Triangle().path(in: insetRect)
        default:
            break
        }
        
        let cornerRadius: CGFloat = {
            let regularRadius = system.cornerRadius(forLength: min(rect.width, rect.height))
            if regularRadius.isZero {
                return 0.0
            } else if system.screenShapeCase == .capsule {
                return system.cornerRadius(forLength: min(insetRect.width, insetRect.height))
            } else if system.cornerStyle == .circular {
                // Use rounded corner style instead
                return system.cornerRadius(forLength: min(rect.width, rect.height), cornerStyle: .rounded) - insetAmount * 2.0
            } else {
                // Min 44 for hardware corner radius
                return max(44.0, (regularRadius / 2.0)) - insetAmount * 2.0
            }
        }()
        let screenTrapezoidHexagonCornerOffset = max(44, rect.width/8)
        let replacableWidth: CGFloat = {
            switch system.screenShapeCase {
            case .croppedCircle:
                return insetRect.width - screenTrapezoidHexagonCornerOffset*2.0
            case .hexagon:
                let riseOverRun = (insetRect.height/2) / screenTrapezoidHexagonCornerOffset
                let angle = atan(riseOverRun)
                let offset = cornerRadius * abs(tan(angle / 2.0))
                return insetRect.width - (screenTrapezoidHexagonCornerOffset + offset)*2.0
            case .trapezoid:
                let topSideLength = insetRect.width - screenTrapezoidHexagonCornerOffset*2
                let topLeadingSpace = (insetRect.width - topSideLength)/2
                let riseOverRun = insetRect.height / topLeadingSpace
                let angle = atan(riseOverRun)
                let topOffset = cornerRadius * abs(tan(angle / 2.0))
                return insetRect.width - (screenTrapezoidHexagonCornerOffset + topOffset)*2.0
            default:
                return insetRect.width - cornerRadius*2.0
            }
        }()
        let replacableHeight: CGFloat = {
            if system.screenShapeCase == .croppedCircle {
                return insetRect.height - screenTrapezoidHexagonCornerOffset*2.0
            } else {
                return insetRect.height - cornerRadius*2.0
            }
        }()
        let cutoutHeight = ScreenShape.cutoutHeight
        
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
        let maxCutoutContentWidth = replacableWidth - totalTransitionWidth
        let absoluteMaxCutoutContentWidth = 600.0 + insetAmount*2.0
        let iPhoneNotchWidth: CGFloat = 200.0
        let preferedCutoutContentWidth = max(rect.width*0.35 + insetAmount*2.0, iPhoneNotchWidth)
        let cutoutContentWidth = min(preferedCutoutContentWidth, maxCutoutContentWidth, absoluteMaxCutoutContentWidth)
        let totalLengthAroundCutout = (replacableWidth - cutoutContentWidth - totalTransitionWidth)
        let topLeadingLengthBeforeCutout: CGFloat
        let topTrailingLengthAfterCutout: CGFloat
        let bottomLeadingLengthBeforeCutout: CGFloat
        let bottomTrailingLengthAfterCutout: CGFloat
        
        if 200 < totalLengthAroundCutout {
            switch system.getTopCutoutPosition() {
            case .leading:
                topLeadingLengthBeforeCutout = totalLengthAroundCutout * 0.333333
                topTrailingLengthAfterCutout = totalLengthAroundCutout * 0.666666
            case .trailing:
                topLeadingLengthBeforeCutout = totalLengthAroundCutout * 0.666666
                topTrailingLengthAfterCutout = totalLengthAroundCutout * 0.333333
            default:
                topLeadingLengthBeforeCutout = totalLengthAroundCutout/2
                topTrailingLengthAfterCutout = totalLengthAroundCutout/2
            }
            switch system.bottomCutoutPosition {
            case .leading:
                bottomLeadingLengthBeforeCutout = totalLengthAroundCutout * 0.333333
                bottomTrailingLengthAfterCutout = totalLengthAroundCutout * 0.666666
            case .trailing:
                bottomLeadingLengthBeforeCutout = totalLengthAroundCutout * 0.666666
                bottomTrailingLengthAfterCutout = totalLengthAroundCutout * 0.333333
            default:
                bottomLeadingLengthBeforeCutout = totalLengthAroundCutout/2
                bottomTrailingLengthAfterCutout = totalLengthAroundCutout/2
            }
        } else {
            topLeadingLengthBeforeCutout = totalLengthAroundCutout/2
            topTrailingLengthAfterCutout = totalLengthAroundCutout/2
            bottomLeadingLengthBeforeCutout = totalLengthAroundCutout/2
            bottomTrailingLengthAfterCutout = totalLengthAroundCutout/2
        }
        
        // MARK: Return
        return Path { path in
            // Start at bottom left and go counter-clockwise
            let startXOffset: CGFloat = {
                switch system.screenShapeCase {
                case .croppedCircle:
                    if insetRect.width < insetRect.height {
                        return 0
                    } else {
                        return screenTrapezoidHexagonCornerOffset
                    }
                case .hexagon:
                    let riseOverRun = (insetRect.height/2) / screenTrapezoidHexagonCornerOffset
                    let angle = atan(riseOverRun)
                    let offset = cornerRadius * abs(tan(angle / 2.0))
                    return screenTrapezoidHexagonCornerOffset + offset
                case .trapezoid:
                    let topSideLength = insetRect.width - screenTrapezoidHexagonCornerOffset*2
                    let topLeadingSpace = (insetRect.size.width - topSideLength)/2
                    let riseOverRun = insetRect.size.height / topLeadingSpace
                    let angle = atan(riseOverRun)
                    let topOffset = cornerRadius * abs(tan(angle / 2.0))
                    return screenTrapezoidHexagonCornerOffset + topOffset
                default:
                    return cornerRadius
                }
            }()
            var point = CGPoint(x: insetAmount + startXOffset, y: insetAmount + insetRect.height)
            path.move(to: point)
            
            let horizontalStraightLengthIsZero: Bool = {
                switch system.screenShapeCase {
                case .hexagon, .croppedCircle, .capsule:
                    return insetRect.width < insetRect.height
                default:
                    return false
                }
            }()
            
            if !horizontalStraightLengthIsZero {
                point.x += bottomLeadingLengthBeforeCutout
                path.addLine(to: point)
                
                // MARK: Bottom Cutout
                let bottomCutoutStyle = system.bottomCutoutStyle(screenSize: rect.size, availableWidth: replacableWidth, insetAmount: insetAmount)
                let bottomCutoutPoints = cutoutPoints(style: bottomCutoutStyle, length: cutoutContentWidth + totalTransitionWidth, cutoutHeight: cutoutHeight).map({
                    CGPoint(x: point.x + $0.x, y: point.y - $0.y)
                })
                switch bottomCutoutStyle {
                case .angle45:
                    path.addLine(to: bottomCutoutPoints[0])
                    path.addLine(to: bottomCutoutPoints[1])
                    path.addLine(to: bottomCutoutPoints[2])
                case .roundedAngle45:
                    let radius = cutoutHeight
                    path.addRelativeArc(center: bottomCutoutPoints[0], radius: radius, startAngle: Angle(degrees: 90), delta: Angle(radians: -Double.pi/4))
                    path.addRelativeArc(center: bottomCutoutPoints[1], radius: radius, startAngle: Angle(radians: .pi*5/4), delta: Angle(radians: Double.pi/4))
                    path.addLine(to: bottomCutoutPoints[2])
                    path.addRelativeArc(center: bottomCutoutPoints[3], radius: radius, startAngle: Angle(radians: .pi*3/2), delta: Angle(radians: Double.pi/4))
                    path.addRelativeArc(center: bottomCutoutPoints[4], radius: radius, startAngle: Angle(radians: .pi*3/4), delta: Angle(radians: -Double.pi/4))
                case .halfRounded:
                    let radius = cutoutHeight
                    path.addRelativeArc(center: bottomCutoutPoints[0], radius: radius, startAngle: Angle(radians: .pi), delta: Angle(radians: Double.pi/2.0))
                    path.addLine(to: bottomCutoutPoints[1])
                    path.addRelativeArc(center: bottomCutoutPoints[2], radius: radius, startAngle: Angle(radians: -.pi/2), delta: Angle(radians: Double.pi/2.0))
                case .roundedRectangle:
                    let radius = cutoutHeight / 2.0
                    path.addRelativeArc(center: bottomCutoutPoints[0], radius: radius, startAngle: Angle(radians: .pi/2), delta: Angle(radians: -Double.pi/2.0))
                    path.addRelativeArc(center: bottomCutoutPoints[1], radius: radius, startAngle: Angle(radians: .pi), delta: Angle(radians: Double.pi/2.0))
                    path.addLine(to: bottomCutoutPoints[2])
                    path.addRelativeArc(center: bottomCutoutPoints[3], radius: radius, startAngle: Angle(radians: .pi*3/2), delta: Angle(radians: Double.pi/2.0))
                    path.addRelativeArc(center: bottomCutoutPoints[4], radius: radius, startAngle: Angle(radians: .pi), delta: Angle(radians: -Double.pi/2.0))
                case .curved:
                    path.addQuadCurve(to: bottomCutoutPoints[0], control: bottomCutoutPoints[1])
                    path.addLine(to: bottomCutoutPoints[2])
                    path.addQuadCurve(to: bottomCutoutPoints[3], control: bottomCutoutPoints[4])
                case .none:
                    path.addLine(to: bottomCutoutPoints[0])
                }
                point.x += cutoutContentWidth + totalTransitionWidth
                
                point = path.currentPoint!
                point.x += bottomTrailingLengthAfterCutout
                path.addLine(to: point)
            }
            
            // MARK: Right + Top + Left Sides
            switch system.screenShapeCase {
            case .hexagon:
                let modifiedInsetRect: CGRect = {
                    if insetRect.height <= insetRect.width {
                        return insetRect
                    } else {
                        return CGRect(x: insetRect.origin.y, y: insetRect.origin.x, width: insetRect.height, height: insetRect.width)
                    }
                }()
                let sharpPoints = [
                    CGPoint(x: modifiedInsetRect.maxX - screenTrapezoidHexagonCornerOffset, y: modifiedInsetRect.maxY),
                    CGPoint(x: modifiedInsetRect.maxX, y: modifiedInsetRect.midY),
                    CGPoint(x: modifiedInsetRect.maxX - screenTrapezoidHexagonCornerOffset, y: modifiedInsetRect.minY),
                    CGPoint(x: modifiedInsetRect.minX + screenTrapezoidHexagonCornerOffset, y: modifiedInsetRect.minY),
                    CGPoint(x: modifiedInsetRect.minX, y: modifiedInsetRect.midY),
                    CGPoint(x: modifiedInsetRect.minX + screenTrapezoidHexagonCornerOffset, y: modifiedInsetRect.maxY)
                ]
                var points = [CGPoint]()
                let riseOverRun = (modifiedInsetRect.height/2) / screenTrapezoidHexagonCornerOffset
                let angle = atan(riseOverRun)
                let offset = cornerRadius * abs(tan(angle / 2.0))
                
                let offsetXComponent = offset * cos(angle)
                let offsetYComponent = offset * sin(angle)
                
                let sharpPoint0 = sharpPoints[0]
                if !cornerRadius.isZero {
                    points.append(CGPoint(x: sharpPoint0.x - offset, y: sharpPoint0.y))
                    points.append(sharpPoint0)
                    points.append(CGPoint(x: sharpPoint0.x + offsetXComponent, y: sharpPoint0.y - offsetYComponent))
                } else {
                    points.append(sharpPoint0)
                }
                
                let sharpPoint1 = sharpPoints[1]
                if !cornerRadius.isZero {
                    points.append(CGPoint(x: sharpPoint1.x - offsetXComponent, y: sharpPoint1.y + offsetYComponent))
                    points.append(sharpPoint1)
                    points.append(CGPoint(x: sharpPoint1.x - offsetXComponent, y: sharpPoint1.y - offsetYComponent))
                } else {
                    points.append(sharpPoint1)
                }
                
                let sharpPoint2 = sharpPoints[2]
                if !cornerRadius.isZero {
                    points.append(CGPoint(x: sharpPoint2.x + offsetXComponent, y: sharpPoint2.y + offsetYComponent))
                    points.append(sharpPoint2)
                    points.append(CGPoint(x: sharpPoint2.x - offset, y: sharpPoint2.y))
                } else {
                    points.append(sharpPoint2)
                }
                
                let sharpPoint3 = sharpPoints[3]
                if !cornerRadius.isZero {
                    points.append(CGPoint(x: sharpPoint3.x + offset, y: sharpPoint3.y))
                    points.append(sharpPoint3)
                    points.append(CGPoint(x: sharpPoint3.x - offsetXComponent, y: sharpPoint3.y + offsetYComponent))
                } else {
                    points.append(sharpPoint3)
                }
                
                let sharpPoint4 = sharpPoints[4]
                if !cornerRadius.isZero {
                    points.append(CGPoint(x: sharpPoint4.x + offsetXComponent, y: sharpPoint4.y - offsetYComponent))
                    points.append(sharpPoint4)
                    points.append(CGPoint(x: sharpPoint4.x + offsetXComponent, y: sharpPoint4.y + offsetYComponent))
                } else {
                    points.append(sharpPoint4)
                }
                
                let sharpPoint5 = sharpPoints[5]
                if !cornerRadius.isZero {
                    points.append(CGPoint(x: sharpPoint5.x - offsetXComponent, y: sharpPoint5.y - offsetYComponent))
                    points.append(sharpPoint5)
                    points.append(CGPoint(x: sharpPoint5.x + offset, y: sharpPoint5.y))
                } else {
                    points.append(sharpPoint5)
                }
                
                if insetRect.width < insetRect.height {
                    points = points.map({ CGPoint(x: $0.y, y: $0.x) }) // Rotate 90
                    path.move(to: points.last!)
                }
                
                for _ in 0..<3 {
                    path.addLine(to: points.removeFirst())
                    if !cornerRadius.isZero {
                        path.addArc(tangent1End: points.removeFirst(), tangent2End: points.removeFirst(), radius: cornerRadius)
                    }
                }
                if insetRect.height <= insetRect.width {
                    addTopCutout(path: &path, point: &point, screenSize: rect.size, replacableWidth: replacableWidth, topTrailingLengthAfterCutout: topTrailingLengthAfterCutout, cutoutContentWidth: cutoutContentWidth, totalTransitionWidth: totalTransitionWidth, cutoutHeight: cutoutHeight, topLeadingLengthBeforeCutout: topLeadingLengthBeforeCutout)
                }
                for _ in 0..<3 {
                    path.addLine(to: points.removeFirst())
                    if !cornerRadius.isZero {
                        path.addArc(tangent1End: points.removeFirst(), tangent2End: points.removeFirst(), radius: cornerRadius)
                    }
                }
            case .trapezoid:
                let topSideLength = insetRect.width - screenTrapezoidHexagonCornerOffset*2
                var points = Trapezoid().roundedTrapezoidPathPoints(in: insetRect, topSideLength: topSideLength, cornerRadius: cornerRadius)
                
                if system.shapeDirection == .down {
                    let flipped = points.map({ CGPoint(x: $0.x, y: rect.maxY - $0.y) }) // Flip
                    points = Array(flipped[0..<flipped.count/2].reversed()) + Array(flipped[flipped.count/2..<flipped.count].reversed())
                }
                
                for i in 0..<2 {
                    if i == 0, !cornerRadius.isZero {
                        points.removeFirst()
                    } else {
                        path.addLine(to: points.removeFirst())
                    }
                    if !cornerRadius.isZero {
                        path.addArc(tangent1End: points.removeFirst(), tangent2End: points.removeFirst(), radius: cornerRadius)
                    }
                }
                if system.shapeDirection == .down {
                    point = path.currentPoint!
                    point.x -= screenTrapezoidHexagonCornerOffset
                    path.addLine(to: point)
                }
                addTopCutout(path: &path, point: &point, screenSize: rect.size, replacableWidth: replacableWidth, topTrailingLengthAfterCutout: topTrailingLengthAfterCutout, cutoutContentWidth: cutoutContentWidth, totalTransitionWidth: totalTransitionWidth, cutoutHeight: cutoutHeight, topLeadingLengthBeforeCutout: topLeadingLengthBeforeCutout)
                for i in 0..<2 {
                    if i == 0, !cornerRadius.isZero {
                        points.removeFirst()
                    } else {
                        path.addLine(to: points.removeFirst())
                    }
                    if !cornerRadius.isZero {
                        path.addArc(tangent1End: points.removeFirst(), tangent2End: points.removeFirst(), radius: cornerRadius)
                    }
                }
            case .croppedCircle:
                if insetRect.height <= insetRect.width {
                    var c1a = point
                    c1a.x += screenTrapezoidHexagonCornerOffset
                    point.y -= insetRect.height
                    var c2a = point
                    c2a.x += screenTrapezoidHexagonCornerOffset
                    path.addCurve(to: point, control1: c1a, control2: c2a)
                    addTopCutout(path: &path, point: &point, screenSize: rect.size, replacableWidth: replacableWidth, topTrailingLengthAfterCutout: topTrailingLengthAfterCutout, cutoutContentWidth: cutoutContentWidth, totalTransitionWidth: totalTransitionWidth, cutoutHeight: cutoutHeight, topLeadingLengthBeforeCutout: topLeadingLengthBeforeCutout)
                    var c1b = point
                    c1b.x -= screenTrapezoidHexagonCornerOffset
                    point.y += insetRect.height
                    var c2b = point
                    c2b.x -= screenTrapezoidHexagonCornerOffset
                    path.addCurve(to: point, control1: c1b, control2: c2b)
                } else {
                    point.y -= screenTrapezoidHexagonCornerOffset
                    path.move(to: point)
                    
                    var c1a = point
                    c1a.y += screenTrapezoidHexagonCornerOffset
                    point.x += insetRect.width
                    var c2a = point
                    c2a.y += screenTrapezoidHexagonCornerOffset
                    path.addCurve(to: point, control1: c1a, control2: c2a)
                    
                    point.y -= replacableHeight
                    path.addLine(to: point)
                    
                    var c1b = point
                    c1b.y -= screenTrapezoidHexagonCornerOffset
                    point.x -= insetRect.width
                    var c2b = point
                    c2b.y -= screenTrapezoidHexagonCornerOffset
                    path.addCurve(to: point, control1: c1b, control2: c2b)
                    
                    point.y += replacableHeight
                    path.addLine(to: point)
                }
            default:
                point.y -= cornerRadius
                path.addRelativeArc(center: point, radius: cornerRadius, startAngle: Angle(radians: .pi/2), delta: Angle(radians: -Double.pi/2.0))
                point.x += cornerRadius
                point.y -= replacableHeight
                path.addLine(to: point)
                point.x -= cornerRadius
                path.addRelativeArc(center: point, radius: cornerRadius, startAngle: Angle.zero, delta: Angle(radians: -.pi/2.0))
                point = path.currentPoint!
                addTopCutout(path: &path, point: &point, screenSize: rect.size, replacableWidth: replacableWidth, topTrailingLengthAfterCutout: topTrailingLengthAfterCutout, cutoutContentWidth: cutoutContentWidth, totalTransitionWidth: totalTransitionWidth, cutoutHeight: cutoutHeight, topLeadingLengthBeforeCutout: topLeadingLengthBeforeCutout)
                path.addLine(to: point)
                point.y += cornerRadius
                path.addRelativeArc(center: point, radius: cornerRadius, startAngle: Angle(radians: -.pi/2), delta: Angle(radians: -.pi/2.0))
                point.x -= cornerRadius
                point.y += replacableHeight
                path.addLine(to: point)
                point = path.currentPoint!
                point.x += cornerRadius
                path.addRelativeArc(center: point, radius: cornerRadius, startAngle: Angle(radians: -(.pi/2) - .pi/2.0), delta: Angle(radians: -Double.pi/2.0))
            }
            
            path.closeSubpath()
        }
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
}