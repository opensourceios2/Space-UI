//
//  AutoGrid.swift
//  Space UI
//
//  Created by Jayden Irwin on 2020-12-06.
//  Copyright © 2020 Jayden Irwin. All rights reserved.
//

import SwiftUI

// Input: 4 children -> Output layouts: 1x4, 2x2, 4x1
// Input: 5 children -> Output layouts: 1x5, 5x1
// Also allows triangles to layout in alternating direction: 🔺🔻🔺🔻 // TODO: .environment(\.shapeDirection, col % 2 == 0 ? .up : .down)

struct AutoGrid: Layout {
    
    var spacing: CGFloat = 20
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let avgSubviewSize = avgSubviewSize(subviews)
        return proposedGridAndSize(proposal: proposal, subviews: subviews, avgSubviewSize: avgSubviewSize).size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let avgSubviewSize = avgSubviewSize(subviews)
        let proposedGridAndSize = proposedGridAndSize(proposal: proposal, subviews: subviews, avgSubviewSize: avgSubviewSize)
        let firstSubviewPoint = CGPoint(x: bounds.minX + avgSubviewSize.width/2, y: bounds.minY + avgSubviewSize.height/2)
        
        for (index, subview) in subviews.enumerated() {
            let gridIndex = gridIndex(subviewIndex: index, rows: proposedGridAndSize.rows, columns: proposedGridAndSize.columns)
            
            let point = CGPoint(
                x: firstSubviewPoint.x + (avgSubviewSize.width + spacing) * CGFloat(gridIndex.column),
                y: firstSubviewPoint.y + (avgSubviewSize.height + spacing) * CGFloat(gridIndex.row))
            
            subview.place(at: point, anchor: .center, proposal: .unspecified)
        }
    }
    
    private func avgSubviewSize(_ subviews: Subviews) -> CGSize {
        let finiteSubviewSizes: [CGSize] = subviews.compactMap {
            let size = $0.sizeThatFits(.infinity)
            if size.width == .infinity || size.height == .infinity {
                return nil
            } else {
                return size
            }
        }
        if finiteSubviewSizes.isEmpty {
            // Default subview is square
            return CGSize(width: 100, height: 100)
        } else {
            let totalSize = finiteSubviewSizes.reduce(.zero, { CGSize(width: $0.width + $1.width, height: $0.width + $1.width) })
            return CGSize(width: totalSize.width / CGFloat(finiteSubviewSizes.count), height: totalSize.height / CGFloat(finiteSubviewSizes.count))
        }
    }
    
    private func proposedGridAndSize(proposal: ProposedViewSize, subviews: Subviews, avgSubviewSize: CGSize) -> (rows: Int, columns: Int, size: CGSize) {
        var bestGrid = (1, subviews.count)
        var bestGridScore: CGFloat = .infinity
        
        for grid in gridDimensions(of: subviews.count) {
            let thisSize = CGSize(width: avgSubviewSize.width * CGFloat(grid.0), height: avgSubviewSize.height * CGFloat(grid.1))
            let thisScore = aspectRatioDifference(thisSize, proposal.aspectRatio)
            if thisScore < bestGridScore {
                bestGrid = (grid.0, grid.1)
                bestGridScore = thisScore
            }
        }
        
        let size = CGSize(
            width: CGFloat(bestGrid.1) * avgSubviewSize.width + CGFloat(bestGrid.1 - 1) * spacing,
            height: CGFloat(bestGrid.0) * avgSubviewSize.height + CGFloat(bestGrid.0 - 1) * spacing)
        return (bestGrid.0, bestGrid.1, size)
    }
    
    private func gridIndex(subviewIndex: Int, rows: Int, columns: Int) -> (row: Int, column: Int) {
        (subviewIndex / columns, subviewIndex % columns)
    }
    
    private func gridDimensions(of n: Int) -> [(Int, Int)] {
        precondition(n > 0, "n must be positive")
        let sqrtn = Int(Double(n).squareRoot())
        var factors: [(Int, Int)] = []
        for i in 1...sqrtn {
            if n % i == 0 {
                factors.append((i, n/i))
                if i != n/i {
                    factors.append((n/i, i))
                }
            }
        }
        return factors
    }
    
}

struct AutoGrid_Previews: PreviewProvider {
    static var previews: some View {
        AutoGrid(spacing: 8) {
            Text("Hello")
            Text("World")
        }
    }
}
