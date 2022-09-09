//
//  DesignPrinciples.swift
//  Space UI
//
//  Created by Jayden Irwin on 2022-09-07.
//  Copyright © 2022 Jayden Irwin. All rights reserved.
//

import GameplayKit

final class DesignPrinciples {
    
    let simplicity: Double
    let sharpness: Double
    let order: Double
    let balance: Double
    
    init(simplicity: Double = 0.5, sharpness: Double = 0.5, order: Double = 0.5, balance: Double = 0.5) {
        self.simplicity = simplicity
        self.sharpness = sharpness
        self.order = order
        self.balance = balance
    }
    
    func similarity(to other: DesignPrinciples) -> Double {
        (abs(simplicity - other.simplicity) + abs(sharpness - other.sharpness) + abs(order - other.order) + abs(balance - other.balance)) / 4
    }
    
}
