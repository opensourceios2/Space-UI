//
//  AutoStack.swift
//  Space UI
//
//  Created by Jayden Irwin on 2019-12-28.
//  Copyright © 2019 Jayden Irwin. All rights reserved.
//

import SwiftUI

struct AutoStack: Layout {
    
    private enum Alignment {
        case horizontal, vertical
    }
    
    var spacing: CGFloat = 20
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        proposedAlignmentAndSize(proposal: proposal, subviews: subviews).size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        
        let alignmentAndSize = proposedAlignmentAndSize(proposal: proposal, subviews: subviews)
        
        if alignmentAndSize.alignment == .horizontal {
            let totalSpacing = spacing * CGFloat(subviews.count-1)
            var sizes: [Int: CGSize] = [:]
            
            // 1st pass: calculate non-expandable widths
            for index in subviews.indices {
                let maxSize = subviews[index].sizeThatFits(.infinity)
                if maxSize.width != .infinity {
                    sizes[index] = CGSize(width: maxSize.width, height: min(maxSize.height, alignmentAndSize.size.height))
                }
            }
            
            // 2nd pass: calculate remaining widths
            let expandableSubviewsCount = subviews.count - sizes.count
            let remainingWidth = alignmentAndSize.size.width - (sizes.values.reduce(0, { $0 + $1.width }) + totalSpacing)
            let expandableSubviewWidth = remainingWidth / CGFloat(expandableSubviewsCount)
            for index in subviews.indices {
                if sizes[index] == nil {
                    let maxSize = subviews[index].sizeThatFits(.infinity)
                    sizes[index] = CGSize(width: expandableSubviewWidth, height: min(maxSize.height, alignmentAndSize.size.height))
                }
            }
            
            // Place subviews
            let totalWidth = sizes.values.reduce(0, { $0 + $1.width }) + totalSpacing
            var x = bounds.midX - (totalWidth / 2)
            for index in subviews.indices {
                let size = sizes[index]!
                
                x += size.width / 2
                
                subviews[index].place(at: CGPoint(x: x, y: bounds.midY), anchor: .center, proposal: ProposedViewSize(size))
                
                x += (size.width / 2) + spacing
            }
        } else {
            let totalSpacing = spacing * CGFloat(subviews.count-1)
            var sizes: [Int: CGSize] = [:]
            
            // 1st pass: calculate non-expandable widths
            for index in subviews.indices {
                let maxSize = subviews[index].sizeThatFits(.infinity)
                if maxSize.height != .infinity {
                    sizes[index] = CGSize(width: min(maxSize.width, alignmentAndSize.size.width), height: maxSize.height)
                }
            }
            
            // 2nd pass: calculate remaining widths
            let expandableSubviewsCount = subviews.count - sizes.count
            let remainingHeight = alignmentAndSize.size.height - (sizes.values.reduce(0, { $0 + $1.height }) + totalSpacing)
            let expandableSubviewHeight = remainingHeight / CGFloat(expandableSubviewsCount)
            for index in subviews.indices {
                if sizes[index] == nil {
                    let maxSize = subviews[index].sizeThatFits(.infinity)
                    sizes[index] = CGSize(width: min(maxSize.width, alignmentAndSize.size.width), height: expandableSubviewHeight)
                }
            }
            
            // Place subviews
            let totalHeight = sizes.values.reduce(0, { $0 + $1.height }) + totalSpacing
            var y = bounds.midY - (totalHeight / 2)
            for index in subviews.indices {
                let size = sizes[index]!
                
                y += size.height / 2
                
                subviews[index].place(at: CGPoint(x: bounds.midX, y: y), anchor: .center, proposal: ProposedViewSize(size))
                
                y += (size.height / 2) + spacing
            }
        }
    }
    
    private func proposedAlignmentAndSize(proposal: ProposedViewSize, subviews: Subviews) -> (alignment: Alignment, size: CGSize) {
        
        func nonInfiniteSize(for size: CGSize) -> CGSize {
            let width = (size.width == .infinity) ? (proposal.width ?? 1000) : size.width
            let height = (size.height == .infinity) ? (proposal.height ?? 1000) : size.height
            return CGSize(width: width, height: height)
        }
        
        let totalSpacing = spacing * CGFloat(subviews.count-1)
        let hStackSize = subviews.reduce(CGSize(width: totalSpacing, height: 0)) { result, subview in
            let size = subview.idealSize
            return CGSize(
                width: result.width + size.width,
                height: max(result.height, size.height))
        }
        let vStackSize = subviews.reduce(CGSize(width: 0, height: totalSpacing)) { result, subview in
            let size = subview.idealSize
            return CGSize(
                width: max(result.width, size.width),
                height: result.height + size.height)
        }
        
        let alignment: Alignment = {
            switch (hStackSize.width, hStackSize.height) {
            case (.infinity, .infinity):
                let proposalIsLandscape = proposal.height ?? 0 <= proposal.width ?? 0
                return proposalIsLandscape ? .horizontal : .vertical
            case (.infinity, _):
                return .vertical
            case (_, .infinity):
                return .horizontal
            default:
                let hStackRatioDifference = aspectRatioDifference(hStackSize, proposal.aspectRatio)
                let vStackRatioDifference = aspectRatioDifference(vStackSize, proposal.aspectRatio)
                return hStackRatioDifference < vStackRatioDifference ? .horizontal : .vertical
            }
        }()
        
        return (alignment == .horizontal) ? (alignment, nonInfiniteSize(for: hStackSize)) : (alignment, nonInfiniteSize(for: vStackSize))
    }
    
}

struct AutoStack_Previews: PreviewProvider {
    static var previews: some View {
        AutoStack {
            Text("1")
            Text("2")
            Text("3")
            Text("4")
            Text("5")
        }
    }
}
