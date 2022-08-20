//
//  DecorativeBoxesView.swift
//  Space UI
//
//  Created by Jayden Irwin on 2020-01-01.
//  Copyright © 2020 Jayden Irwin. All rights reserved.
//

import SwiftUI
import GameplayKit

// Example of what this looks like:
// [][][]
// []  []
// []

struct DecorativeBoxesView: View {
    
    let values: [Int]
    
    var body: some View {
        HStack(alignment: .top, spacing: 3) {
            ForEach(values.indices, id: \.self) { x in
                VStack(spacing: 3) {
                    ForEach(0..<self.values[x], id: \.self) { _ in
                        RoundedRectangle(cornerRadius: system.cornerRadius(forLength: 8))
                            .frame(width: 8, height: 8)
                    }
                }
            }
        }
    }
    
    init() {
        if Bool.random() {
            values = [
                Int.random(in: 1...3),
                Int.random(in: 1...3)
            ]
        } else {
            values = [
                Int.random(in: 1...3),
                Int.random(in: 1...3),
                Int.random(in: 1...3)
            ]
        }
    }
    
}

struct DecorativeBoxesView_Previews: PreviewProvider {
    static var previews: some View {
        DecorativeBoxesView()
    }
}
