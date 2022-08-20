//
//  Icons.swift
//  Space UI
//
//  Created by Jayden Irwin on 2019-12-19.
//  Copyright © 2019 Jayden Irwin. All rights reserved.
//

import GameplayKit

enum CircleIcon: String, CaseIterable {
    case circle3Circles, circle6Circles, circleCapsule, circleHexagonSplit, circleHexagon, circleRingSplit, circleRing, circleSplit3, circleSplit4, circleSquare, circleTriangle
    
    static func randomName(random: GKRandom) -> String {
        let index = random.nextInt(upperBound: CircleIcon.allCases.count)
        return CircleIcon.allCases[index].rawValue
    }
}

enum GeneralIcon: String, CaseIterable {
    case asterisk, hexagon, hexagonFill, hexagonSplit, line, plus, squareSplit, triangle
    
    static func randomName(random: GKRandom) -> String {
        let index = random.nextInt(upperBound: GeneralIcon.allCases.count)
        return GeneralIcon.allCases[index].rawValue
    }
}

enum LargeIcon: String, CaseIterable {
    case art, geometric, kagawaFlag, naganoFlag, hexagons3, triforce
    
    static func randomName(random: GKRandom) -> String {
        let index = random.nextInt(upperBound: LargeIcon.allCases.count)
        return LargeIcon.allCases[index].rawValue
    }
}
