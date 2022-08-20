//
//  FillAndBorder.swift
//  Space UI
//
//  Created by Jayden Irwin on 2020-11-29.
//  Copyright © 2020 Jayden Irwin. All rights reserved.
//

import SwiftUI

struct FillAndBorder {
    
    let fill: Color
    let border: Color?
    
    init(fill: Color, border: Color? = nil) {
        self.fill = fill
        self.border = border
    }
    
}
