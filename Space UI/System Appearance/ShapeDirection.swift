//
//  ShapeDirection.swift
//  Space UI
//
//  Created by Jayden Irwin on 2020-12-06.
//  Copyright © 2020 Jayden Irwin. All rights reserved.
//

import SwiftUI

struct ShapeDirectionKey: EnvironmentKey {
    
    static let defaultValue: ShapeDirection = .up
    
}

extension EnvironmentValues {
    
    var shapeDirection: ShapeDirection {
        get {
            return self[ShapeDirectionKey.self]
        }
        set {
            self[ShapeDirectionKey.self] = newValue
        }
    }
    
}
